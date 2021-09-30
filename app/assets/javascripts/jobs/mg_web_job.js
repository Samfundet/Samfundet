
$(function () {
    $("#shrimp-mode-button").click(function (event) {

        $("#shrimp-mode").removeClass("display-none");
        $("#shrimp-mode-button").addClass("display-none");
        $("body").css({"pointer-events":"none"});

        var nShrimps = 10;
        $("#num-shrimp").text("Reker igjen: " + nShrimps)

        // Generate some shrimp
        for(var i=0;i<nShrimps;i++) {

            // Random position & speed
            let pos = 10 + 90 / i;
            let speed = Math.random() * 5 + 2;
            let delayA = Math.random() * speed;
            let delayB = Math.random() * speed;

            // Create css style
            let containerStyle =
                "animation-duration: " + speed + "s;" +
                "top: " + pos + "%;" +
                "animation-delay: -" + delayA + ";";
            let shrimpStyle = "animation-delay: -" + delayB + ";";

            var shrimpHtml = "<div class='shrimp-container' style='" + containerStyle + "'>" +
                       "<div class='shrimp' style='" + shrimpStyle + "'/></div>";

            //.shrimp-container{style: "top: 35%; animation-delay: -4.5s; animation-duration: 10.5s;"}
            //.shrimp.small{style: "animation-delay: -0.7s;"}

            $("#shrimp-container").append(shrimpHtml);
        }

        $(".shrimp-container").click(function (event) {
            $(this).remove();
            nShrimps -= 1;
            $("#num-shrimp").text("Reker igjen: " + nShrimps)

            // Restore site to normal hopefully
            if (nShrimps <= 0) {
                $("#shrimp-mode").addClass("display-none");
                $("#certified-rekefisker").toggleClass("display-none").animate().get(0).scrollIntoView(false)
                $("#shrimp-container").text("")
                $("body").css({"pointer-events":"all"});
                window.scrollBy(0, 200);
            }

        });
    });

});