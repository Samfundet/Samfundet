
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
            let pos = 10.0 + 90.0 / i;
            let speed = Math.random() * 5 + 8;
            let delayA = Math.random() * speed;
            let delayB = Math.random() * speed;

            // Create css style
            let containerStyle =
                "animation-duration: " + speed + "s;" +
                "top: " + pos + "%;" +
                "animation-delay: -" + delayA + "s;";
            let shrimpStyle = "animation-delay: -" + delayB + "s;";

            var shrimpHtml = "<div class='shrimp-container' style='" + containerStyle + "'>" +
                       "<div class='shrimp' style='" + shrimpStyle + "'/></div>";

            //.shrimp-container{style: "top: 35%; animation-delay: -4.5s; animation-duration: 10.5s;"}
            //.shrimp.small{style: "animation-delay: -0.7s;"}

            $("#shrimp-container").append(shrimpHtml);
        }

        // Restore site to normal hopefully
        function restoreSanity(didWin) {
            $("#shrimp-mode").addClass("display-none");
            $("#shrimp-container").text("")
            $("body").css({"pointer-events":"all"});

            if(didWin) {
                $("#certified-rekefisker").toggleClass("display-none").animate().get(0).scrollIntoView(false)
                window.scrollBy(0, 200);
            }else {
                $("#shrimp-mode-button").removeClass("display-none");
            }
        }

        $("#stop-shrimp-mode").click(function (event) {
            restoreSanity(false);
        });
        $(".shrimp-container").click(function (event) {

            nShrimps -= 1;
            $(this).remove();
            $("#num-shrimp").text("Reker igjen: " + nShrimps)

            if (nShrimps <= 0) {
                restoreSanity(true);
            }

        });

    });

});