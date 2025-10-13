from flask import Flask, render_template, request, jsonify
from cognee import SearchType, visualize_graph
import cognee
import asyncio
import os
import pathlib
import logging
from asgiref.wsgi import WsgiToAsgi

# Set up logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route("/", methods=["GET"])
def index():
    logger.debug("Rendering index.html")
    return render_template("index.html")

@app.route("/process", methods=["POST"])
async def process():
    try:
        logger.debug("Processing form submission")
        # Get form data
        text_content = request.form.get("text_content")
        query_text = request.form.get("query_text")

        if not text_content or not query_text:
            logger.warning("Missing content or query")
            return jsonify({"error": "Please provide both content and query."}), 400

        # Reset cognee system
        logger.debug("Pruning cognee data and system")
        await cognee.prune.prune_data()
        await cognee.prune.prune_system(metadata=True)

        # Add and process content
        logger.debug("Adding content to cognee")
        await cognee.add(text_content)
        logger.debug("Cognifying content")
        await cognee.cognify()

        # Generate graph visualization
        graph_file_path = str(
            pathlib.Path(
                os.path.join(pathlib.Path(__file__).parent, "static/graph_visualization.html")
            ).resolve()
        )
        logger.debug(f"Generating graph visualization at {graph_file_path}")
        await visualize_graph(graph_file_path)

        # Perform searches
        logger.debug("Performing graph completion search")
        graph_result = await cognee.search(
            query_text=query_text, query_type=SearchType.GRAPH_COMPLETION
        )
        logger.debug("Performing RAG completion search")
        rag_result = await cognee.search(
            query_text=query_text, query_type=SearchType.RAG_COMPLETION
        )
        logger.debug("Performing basic search")
        basic_result = await cognee.search(
            query_text="What are the main themes in my data?"
        )

        # Clean results by removing square brackets
        def clean_result(result):
            result_str = str(result)
            if result_str.startswith("[") and result_str.endswith("]"):
                return result_str[1:-1].strip()
            return result_str

        logger.debug("Rendering results.html")
        return render_template(
            "results.html",
            graph_result=clean_result(graph_result),
            rag_result=clean_result(rag_result),
            basic_result=clean_result(basic_result),
            graph_file_path=graph_file_path
        )

    except Exception as e:
        logger.error(f"Error in process route: {str(e)}", exc_info=True)
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500
    
app = WsgiToAsgi(app)

if __name__ == "__main__":
    logger.info("Starting Flask application")
    app.run(debug=True, port=5000)