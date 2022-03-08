function previewAttachment(e) {
  var options = { el: e };
  options[e.dataset["bpSrc"]] = e.dataset["url"];
  BigPicture(options);
}
