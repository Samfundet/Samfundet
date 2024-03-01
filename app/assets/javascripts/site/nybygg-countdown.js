
(function () {
  const dateEl = document.getElementById('nybygg-countdown-date')
  if (!dateEl) {
    return;
  }
  const openingDate = new Date(dateEl.getAttribute('data-date'));

  if ((openingDate - new Date()) / 1000 <= 0) {
    return;
  }

  function updateCountdown() {
    const diff = (openingDate - new Date()) / 1000;
    if (diff <= 0) {
      window.location.reload();
    }

    const days = Math.floor(diff / 86400);
    const hours  = Math.floor((diff % 86400) / 3600);
    const minutes  = Math.floor((diff % 3600) / 60);
    const seconds  = Math.floor(diff % 60);

    document.getElementById('nybygg-days').innerText = String(days);
    document.getElementById('nybygg-hours').innerText = String(hours);
    document.getElementById('nybygg-minutes').innerText = String(minutes);
    document.getElementById('nybygg-seconds').innerText = String(seconds);
  }

  updateCountdown();
  setInterval(updateCountdown, 1000);
})();
