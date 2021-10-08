// The conversion process when drawing the page is performed by initAllMermaidMacro().
// After that, initMermaidMacro() is executed separately to support mermaid macro added by ajax, etc.

initAllMermaidMacro();

function initAllMermaidMacro() {
  if (isMermaidjsIsAvailable() === false) { return false; }

  // Hide the target before the change by before-init-mermaid class until mermaid.initialize() or mermaid.init() is executed.
  // After executing mermaid.initialize() or mermaid.init(), remove the before-init-mermaid class to show it (ViewMermaidMacroContent).
  mermaid.initialize({
    startOnLoad: true,
    mermaid: { callback:function() { ViewMermaidMacroContent(); } }
  });
}

function initMermaidMacro(id) {
  if (isMermaidjsIsAvailable() === false) { return false; }

  let target = $('#'+id+'.before-init-mermaid:not(:has(svg))');
  // If you run init on an element in the display: none state, the diagram will not be generated properly. In that case, do not run init.
  // Example: This happens when you open the notes tab of the issue page directly.
  if (target && target.is(':visible')) {
    mermaid.init(undefined, target);
  }
}

function isMermaidjsIsAvailable() {
  if (typeof mermaid === 'undefined') {
    ViewMermaidMacroContent();
    return false;
  }
  return true;
}

function ViewMermaidMacroContent() {
  $('.mermaid').removeClass('before-init-mermaid');
}
