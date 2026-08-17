document$.subscribe(() => {
  mermaid.initialize({ startOnLoad: false, theme: "neutral" });
  mermaid.run({ querySelector: ".mermaid" });
});
