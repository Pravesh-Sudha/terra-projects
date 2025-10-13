document.getElementById("cognee-form").addEventListener("submit", function (e) {
    const textContent = document.getElementById("text_content").value;
    const queryText = document.getElementById("query_text").value;
    if (!textContent || !queryText) {
        e.preventDefault();
        alert("Please fill in both the content and query fields.");
        return;
    }
    // Show loading spinner
    document.getElementById("loading").classList.remove("d-none");
    // Disable submit button to prevent multiple submissions
    document.querySelector("button[type='submit']").disabled = true;
});