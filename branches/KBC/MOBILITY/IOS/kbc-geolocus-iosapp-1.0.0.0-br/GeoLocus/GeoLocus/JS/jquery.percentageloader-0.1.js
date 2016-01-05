//Created by Insurance H3 Team
//
//GeoLocus App
//

(function ($) {
    /* Strict mode for this plugin */
    "use strict";
    /*jslint browser: true */

    /* Our spiral gradient data */
    var imgdata = 	"data:image/png;base64,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",
        gradient = new Image();
    gradient.src = imgdata;

    /** Percentage loader
     * @param	params	Specify options in {}. May be on of width, height, progress or value.
     *
     * @example $("#myloader-container).percentageLoader({
		    width : 256,  // width in pixels
		    height : 256, // height in pixels
		    progress: 0,  // initialise progress bar position, within the range [0..1]
		    value: '0kb'  // initialise text label to this value
		});
     */
    $.fn.percentageLoader = function (params) {
        var settings, canvas, percentageText, valueText, items, i, item, selectors, s, ctx, progress,
            value, cX, cY, lingrad, innerGrad, tubeGrad, innerRadius, innerBarRadius, outerBarRadius,
            radius, startAngle, endAngle, counterClockwise, completeAngle, setProgress, setValue,
            applyAngle, drawLoader, clipValue, outerDiv;

        /* Specify default settings */
        settings = {
            width: 256,
            height: 256,
            progress: 0,
            value: '0kb',
            controllable: false
        };

        /* Override default settings with provided params, if any */
        if (params !== undefined) {
            $.extend(settings, params);
        } else {
            params = settings;
        }

        outerDiv = document.createElement('div');
        outerDiv.style.width = settings.width + 'px';
        outerDiv.style.height = settings.height + 'px';
        outerDiv.style.position = 'relative';

        $(this).append(outerDiv);

        /* Create our canvas object */
        canvas = document.createElement('canvas');
        canvas.setAttribute('width', settings.width);
        canvas.setAttribute('height', settings.height);
        outerDiv.appendChild(canvas);

        /* Create div elements we'll use for text. Drawing text is
         * possible with canvas but it is tricky working with custom
         * fonts as it is hard to guarantee when they become available
         * with differences between browsers. DOM is a safer bet here */
        percentageText = document.createElement('div');
        percentageText.style.width = (settings.width.toString() - 2) + 'px';
        percentageText.style.textAlign = 'center';
        percentageText.style.height = '50px';
        percentageText.style.left = 0;
        percentageText.style.position = 'absolute';

        valueText = document.createElement('div');
        valueText.style.width = (settings.width - 2).toString() + 'px';
        valueText.style.textAlign = 'center';
        valueText.style.height = '0px';
        valueText.style.overflow = 'hidden';
        valueText.style.left = 0;
        valueText.style.position = 'absolute';

        /* Force text items to not allow selection */
        items = [valueText, percentageText];
        for (i  = 0; i < items.length; i += 1) {
            item = items[i];
            selectors = [
                '-webkit-user-select',
                '-khtml-user-select',
                '-moz-user-select',
                '-o-user-select',
                'user-select'];

            for (s = 0; s < selectors.length; s += 1) {
                $(item).css(selectors[s], 'none');
            }
        }

        /* Add the new dom elements to the containing div */
        outerDiv.appendChild(percentageText);
        outerDiv.appendChild(valueText);

        /* Get a reference to the context of our canvas object */
        ctx = canvas.getContext("2d");


        /* Set various initial values */

        /* Centre point */
        cX = (canvas.width / 2) - 1;
        cY = (canvas.height / 2) - 1;

        /* Create our linear gradient for the outer ring */
        lingrad = ctx.createLinearGradient(cX, 0, cX, canvas.height);
        //lingrad.addColorStop(0, '#d6eeff');
        //lingrad.addColorStop(1, '#b6d8f0');
        lingrad.addColorStop(0, '#000000');
        lingrad.addColorStop(1, '#000000');

        /* Create inner gradient for the outer ring */
        innerGrad = ctx.createLinearGradient(cX, cX * 0.133333, cX, canvas.height - cX * 0.133333);
        innerGrad.addColorStop(0, '#f9fcfe');
        innerGrad.addColorStop(1, '#d9ebf7');

        /* Tube gradient (background, not the spiral gradient) */
        tubeGrad = ctx.createLinearGradient(cX, 0, cX, canvas.height);
        tubeGrad.addColorStop(0, '#c1dff4');
        tubeGrad.addColorStop(1, '#aacee6');

        /* The inner circle is 2/3rds the size of the outer one */
        innerRadius = cX * 0.6666;
        /* Outer radius is the same as the width / 2, same as the centre x
        * (but we leave a little room so the borders aren't truncated) */
        radius = cX - 2;

        /* Calculate the radii of the inner tube */
        innerBarRadius = innerRadius + (cX * 0.06);
        outerBarRadius = radius - (cX * 0.06);

        /* Bottom left angle */
        startAngle =4.8257963267949;
        /* Bottom right angle */
        endAngle = 4.8257963267949 + (Math.PI * 2.0);

        /* Nicer to pass counterClockwise / clockwise into canvas functions
        * than true / false */
        counterClockwise = false;

        /* Borders should be 1px */
        ctx.lineWidth = 1;

        /**
         * Little helper method for transforming points on a given
         * angle and distance for code clarity
         */
        applyAngle = function (point, angle, distance) {
            return {
                x : point.x + (Math.cos(angle) * distance),
                y : point.y + (Math.sin(angle) * distance)
            };
        };


        /**
         * render the widget in its entirety.
         */
        drawLoader = function () {
            /* Clear canvas entirely */
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.beginPath();

            /**
             * Helper function - adds a path (without calls to beginPath or closePath)
             * to the context which describes the inner tube. We use this for drawing
             * the background of the inner tube (which is always at 100%) and the
             * progress meter itself, which may vary from 0-100% */
            function makeInnerTubePath(startAngle, endAngle,innerR,outerR) {
				var innerBarRadius=innerR;
				var outerBarRadius=outerR;
				
                var centrePoint, startPoint, controlAngle, capLength, c1, c2, point1, point2;
                centrePoint = {
                    x : cX,
                    y : cY
                };

                startPoint = applyAngle(centrePoint, startAngle, innerBarRadius);

                ctx.moveTo(startPoint.x, startPoint.y);
                point1 = applyAngle(centrePoint, endAngle, innerBarRadius);
                point2 = applyAngle(centrePoint, endAngle, outerBarRadius);

                controlAngle = endAngle + (3.142 / 2.0);
                /* Cap length - a fifth of the canvas size minus 4 pixels */
                capLength = (cX * 0.20) - 4;

                c1 = applyAngle(point1, controlAngle, capLength);
                c2 = applyAngle(point2, controlAngle, capLength);

                ctx.arc(cX, cY, innerBarRadius, startAngle, endAngle, false);
                ctx.bezierCurveTo(c1.x, c1.y, c2.x, c2.y, point2.x, point2.y);
                ctx.arc(cX, cY, outerBarRadius, endAngle, startAngle, true);

                point1 = applyAngle(centrePoint, startAngle, innerBarRadius);
                point2 = applyAngle(centrePoint, startAngle, outerBarRadius);

                controlAngle = startAngle - (3.142 / 2.0);

                c1 = applyAngle(point2, controlAngle, capLength);
                c2 = applyAngle(point1, controlAngle, capLength);

                ctx.bezierCurveTo(c1.x, c1.y, c2.x, c2.y, point1.x, point1.y);
            }

            /* Background tube */
            ctx.beginPath();
            ctx.strokeStyle = '#bcd4e5';
            makeInnerTubePath(startAngle, endAngle,31,32);

            ctx.fillStyle = tubeGrad;
            ctx.fill();
            ctx.stroke();

            /* Calculate angles for the the progress metre */
            completeAngle = startAngle + (progress * (endAngle - startAngle));

            ctx.beginPath();
            makeInnerTubePath(startAngle, completeAngle,innerBarRadius,outerBarRadius);

            /* We're going to apply a clip so save the current state */
            ctx.save();
            /* Clip so we can apply the image gradient */
            ctx.clip();

            /* Draw the spiral gradient over the clipped area */
            ctx.drawImage(gradient, 0, 0, canvas.width, canvas.height);

            /* Undo the clip */
            ctx.restore();

            /* Draw the outline of the path */
            ctx.beginPath();
            makeInnerTubePath(startAngle, completeAngle);
            ctx.stroke();

            /*** TEXT ***/
            (function () {
                var fontSize, string, smallSize, heightRemaining;
                /* Calculate the size of the font based on the canvas size */
                fontSize = cX / 2;

                percentageText.style.top = ((settings.height / 2) - (fontSize / 2)).toString() + 'px';
                percentageText.style.color = '#ffffff';//'#80a9c8';
                percentageText.style.font = fontSize.toString() + 'px Arial';
                //percentageText.style.textShadow = '0 1px 1px #FFFFFF';

                /* Calculate the text for the given percentage */
                string = (progress * 100.0).toFixed(0);

                percentageText.innerHTML = string;

                /* Calculate font and placement of small 'value' text */
                smallSize = cX / 5.5;
                valueText.style.color = '#80a9c8';
                valueText.style.font = smallSize.toString() + 'px Arial';
                valueText.style.height = smallSize.toString() + 'px';
                valueText.style.textShadow = 'None';

                /* Ugly vertical align calculations - fit into bottom ring.
                 * The bottom ring occupes 1/6 of the diameter of the circle */
                heightRemaining = (settings.height * 0.16666666) - smallSize;
                valueText.style.top = ((settings.height * 0.8333333) + (heightRemaining / 4)).toString() + 'px';
            }());
        };

        /**
        * Check the progress value and ensure it is within the correct bounds [0..1]
        */
        clipValue = function () {
            if (progress < 0) {
                progress = 0;
            }

            if (progress > 1.0) {
                progress = 1.0;
            }
        };

        /* Sets the current progress level of the loader
         *
         * @param value the progress value, from 0 to 1. Values outside this range
         * will be clipped
         */
        setProgress = function (value) {
            /* Clip values to the range [0..1] */
            progress = value;
            clipValue();
            drawLoader();
        };

        this.setProgress = setProgress;

        setValue = function (val) {
            value = val;
            valueText.innerHTML = value;
        };

        this.setValue = setValue;
        this.setValue(settings.value);

        progress = settings.progress;
        clipValue();

        /* Do an initial draw */
        drawLoader();

        /* In controllable mode, add event handlers */
        if (params.controllable === true) {
            (function () {
                var mouseDown, getDistance, adjustProgressWithXY;
                getDistance = function (x, y) {
                    return Math.sqrt(Math.pow(x - cX, 2) + Math.pow(y - cY, 2));
                };

                mouseDown = false;

                adjustProgressWithXY = function (x, y) {
                    /* within the bar, calculate angle of touch point */
                    var pX, pY, angle, startTouchAngle, range, posValue;
                    pX = x - cX;
                    pY = y - cY;

                    angle = Math.atan2(pY, pX);
                    if (angle > Math.PI / 2.0) {
                        angle -= (Math.PI * 2.0);
                    }

                    startTouchAngle = startAngle - (Math.PI * 2.0);
                    range = endAngle - startAngle;
                    posValue = (angle - startTouchAngle) / range;
                    setProgress(posValue);

                    if (params.onProgressUpdate) {
                        /* use the progress value as this will have been clipped
                         * to the correct range [0..1] after the call to setProgress
                         */
                        params.onProgressUpdate(progress);
                    }
                };

                $(outerDiv).mousedown(function (e) {
                    var offset, x, y, distance;
                    offset = $(this).offset();
                    x = e.pageX - offset.left;
                    y = e.pageY - offset.top;

                    distance = getDistance(x, y);

                    if (distance > innerRadius && distance < radius) {
                        mouseDown = true;
                        adjustProgressWithXY(x, y);
                    }
                }).mouseup(function () {
                    mouseDown = false;
                }).mousemove(function (e) {
                    var offset, x, y;
                    if (mouseDown) {
                        offset = $(outerDiv).offset();
                        x = e.pageX - offset.left;
                        y = e.pageY - offset.top;
                        adjustProgressWithXY(x, y);
                    }
                }).mouseleave(function () {
                    mouseDown = false;
                });
            }());
        }
        return this;
    };
}(jQuery));
