# 🧠 Cognee AI + Flask + AWS ECS (Terraform)  

This project demonstrates how to build an AI-powered Flask application using **Cognee AI** and deploy it on **AWS ECS** using **Terraform**.  

Cognee AI helps organize your data into AI memory — enabling LLMs to work with context and structured knowledge graphs.

---

## 🚀 Table of Contents
- [About Cognee AI](#-about-cognee-ai)
- [How Cognee Works](#-how-cognee-works)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Local Setup](#-local-setup)
- [Demo Script](#-demo-script)
- [Deploying on AWS ECS](#-deploying-on-aws-ecs)
- [Cleanup](#-cleanup)
- [References](#-references)
- [Connect with Me](#-connect-with-me)

---

## 🧠 About Cognee AI
A one-liner answer to *“What is Cognee AI?”* —  
> **Cognee organizes your data into AI memory.**

When you call an LLM, each request is **stateless** — it doesn’t remember what happened before or know about your documents. Cognee solves this by building a **memory layer** that links your documents together and creates the right context for every LLM call.

👉 [Cognee AI Docs](https://docs.cognee.ai)

---

## 🛠 How Cognee Works

Cognee operates in three main steps:

- **`.add` — Prepare for cognification**  
  Add your data asynchronously. Cognee cleans and prepares your data.

- **`.cognify` — Build a knowledge graph with embeddings**  
  Cognee splits your documents, extracts entities, builds a **queryable graph**, and links it all.

- **`.search` — Query with context**  
  Combines vector similarity + graph traversal to fetch data or generate natural language answers through RAG.

- **`.memify`** *(Coming Soon)* — Adds semantic enrichment to the graph.

---

## 🧰 Tech Stack

- **Flask** – Lightweight Python web framework  
- **Cognee AI** – Memory layer for LLMs  
- **Terraform** – Infrastructure as Code  
- **AWS ECS (Fargate)** – Container orchestration  
- **Docker** – Containerization  
- **Gemini API** – LLM & Embeddings provider

---

## 📁 Project Structure

```
.
├── cognee-flask/
│   ├── app.py
│   ├── testing_cognee.py
│   ├── .env.example
│   ├── requirements.txt
│   └── .artifacts/
│
├── terra-config/
│   ├── provider.tf
│   ├── default_config.tf
│   ├── main.tf
│   ├── get_ip.sh
│
└── README.md

```

---

## 🧪 Local Setup

### 1. Clone the repo
```bash
git clone https://github.com/Pravesh-Sudha/terra-projects.git
cd terra-projects/cognee-flask
````

### 2. Setup environment variables

Create a `.env` file (refer `.env.example`):

```bash
LLM_PROVIDER="gemini"
LLM_MODEL="gemini/gemini-2.5-flash"
LLM_API_KEY="<your-gemini-key>"

# Embeddings
EMBEDDING_PROVIDER="gemini"
EMBEDDING_MODEL="gemini/text-embedding-004"
EMBEDDING_DIMENSIONS="768"
EMBEDDING_API_KEY="<your-gemini-key>"
```

👉 [Get Gemini API Key](https://ai.google.dev/gemini-api)

### 3. Install dependencies

```bash
uv sync
```

---

## 🧠 Demo Script

Run the test file to see how `.add`, `.cognify` and `.search` work:

```bash
uv run testing_cognee.py
```

This will:

* Reset existing data
* Add sample content
* Build a knowledge graph
* Perform search queries (GRAPH_COMPLETION, RAG_COMPLETION, BASIC)
* Store the graph at `.artifacts/graph_visualization.html`

Run the Flask App:

```bash
uv run app.py
```

Visit 👉 [http://localhost:5000](http://localhost:5000)

* Add text → Ask query → View RAG/Graph results
* Click “View Knowledge Graph” to explore the graph.

---

## ☁️ Deploying on AWS ECS

### 1. Navigate to the Terraform config

```bash
cd terra-config
```

### 2. Initialize and apply

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

This will:

* Create an ECS cluster
* Deploy the Flask container
* Configure networking & security groups

### 3. Get the App URL

```bash
chmod u+x get_ip.sh
./get_ip.sh
```

Open the output URL in your browser to access the live Cognee AI app.

---

## 🧹 Cleanup

To avoid extra costs, destroy the infrastructure when not in use:

```bash
terraform destroy --auto-approve
```

---

## 📚 References

* [Cognee AI Docs](https://docs.cognee.ai)
* [Gemini API](https://ai.google.dev/gemini-api)
* [AWS ECS Docs](https://docs.aws.amazon.com/ecs/)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## 🌐 Connect with Me

Hey 👋 I’m **Pravesh Sudha**, a DevOps Engineer & AWS Community Builder.
I love exploring DevOps, AI, and cloud-native technologies.

* 📝 [Blog](https://blog.praveshsudha.com)
* 🐙 [GitHub](https://github.com/Pravesh-Sudha)
* 💼 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha)
* 🐦 [Twitter](https://twitter.com/praveshstwt)

⭐ **If you liked this project, give it a star on GitHub!**
👉 [https://github.com/Pravesh-Sudha/terra-projects](https://github.com/Pravesh-Sudha/terra-projects)