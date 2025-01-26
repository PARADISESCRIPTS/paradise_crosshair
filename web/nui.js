$(function () {
  const reticle = {}; // Declare reticle with const

  reticle.show = function () {
    $(".reticle-wrapper").fadeIn(200);
  };

  reticle.updateColor = function (color) {
    $("#circle").css("background", color || "rgb(255, 255, 255)");
  };

  reticle.hide = function () {
    $(".reticle-wrapper").fadeOut(200);
  };

  window.addEventListener("message", function (event) {
    switch (event.data.display) {
      case "reticleShow":
        reticle.show(event.data.mode);
        break;
      case "reticleHide":
        reticle.hide(event.data);
        break;
      case "reticleColor":
        reticle.updateColor(event.data.color);
        break;
	  case "reticleSize":
		adjustCrosshairSize(event.data.size);
		break;
    }
  });

  console.log("[+] Crosshair Loaded")
  adjustCrosshairSize(3.0); // Adjusts the crosshair size as soon as the script is loaded
});

function adjustCrosshairSize(size) {
  const root = document.querySelector("#circle").style;
  // Adjusts the crosshair size based on the size parameter received from the server
  root.width = `${size}px`;
  root.height = `${size}px`;
}
