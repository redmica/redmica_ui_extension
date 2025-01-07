// Initialize Mermaid globally
function initAllMermaidMacro() {
  if (typeof mermaid === 'undefined') return;

  mermaid.initialize({ startOnLoad: true });
}

// Render a specific Mermaid macro by selector
// NOTE: If `document.readyState` is not 'complete', no extra conversion is needed because `initAllMermaidMacro` handles it.  
//       However, if `document.readyState` is not 'complete', it means the element was added dynamically (e.g., via AJAX), so it should be converted separately.
function renderMermaidMacro(selector) {
  if (typeof mermaid === 'undefined' || document.readyState !== 'complete') return;

  mermaid.run({ querySelector: selector });
}

initAllMermaidMacro();
