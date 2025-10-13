from cognee import SearchType, visualize_graph
import cognee 
import asyncio
import os, pathlib

async def main():

    # Create a clean slate for cognee -- reset data and system state
    await cognee.prune.prune_data()
    await cognee.prune.prune_system(metadata=True)

    # Add sample content
    text = "Pravesh Sudha is a DevOps Engineer, AWS Community Builder and Content Creator. He loves to try out new AI tool like Cognee AI, Portia AI and Runner-H. He shares his learning on his socials and detailed blogs on Hashnode, Dev.to and medium along with Detailed project tutorial on Youtube"

    await cognee.add(text)

    # Process with LLMs to build the knowledge graph
    await cognee.cognify()

    graph_file_path = str(
        pathlib.Path(
            os.path.join(pathlib.Path(__file__).parent, ".artifacts/graph_visualization.html")
        ).resolve()
    )
    await visualize_graph(graph_file_path)


    # Search the knowledge graph
    graph_result = await cognee.search(
        query_text="What does Pravesh Sudha do?", query_type=SearchType.GRAPH_COMPLETION
    )
    print("Graph Result: ")
    print(graph_result)

    rag_result = await cognee.search(
        query_text="What does Pravesh Sudha do?", query_type=SearchType.RAG_COMPLETION
    )
    print("RAG Result: ")
    print(rag_result)

    basic_result = await cognee.search(
        query_text="What are the main themes in my data?"
    )
    print("Basic Result: ")
    print(basic_result)


if __name__ == '__main__':
    asyncio.run(main())
