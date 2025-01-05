(function () {
  function onScroll() {
    if (window.scrollY > 0) {
      document.getElementById("header").classList.add("scrolled")
    } else {
      document.getElementById("header").classList.remove("scrolled")
    }
  }
  document.addEventListener('scroll', onScroll);
})();