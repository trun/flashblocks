package com.flashblocks.logoblocks {
    import flash.display.BitmapData;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import mx.core.UIComponent;
    import mx.graphics.ImageSnapshot;
    import mx.graphics.ImageSnapshot;
    import mx.graphics.ImageSnapshot;

    public class LogoCanvas extends UIComponent {
        private var xVal:Number;
        private var yVal:Number;
        private var rotVal:Number;
        private var _penUp:Boolean;
        private var _penColor:uint;
        private var xMin:Number, xMax:Number;
        private var yMin:Number, yMax:Number;

        private var turtleCursor:UIComponent;

        public function LogoCanvas() {
            turtleCursor = new UIComponent();
            addChild(turtleCursor);
            reset();
            redrawTurtle();
        }

        public function get penUp():Boolean {
            return _penUp;
        }

        public function set penUp(value:Boolean):void {
            _penUp = value;
            redrawTurtle();
        }

        public function get penColor():uint {
            return _penColor;
        }

        public function set penColor(value:uint):void {
            _penColor = value;
            graphics.lineStyle(2, value);
            redrawTurtle();
        }

        public function reset():void {
            xVal = 0;
            yVal = 0;
            xMin = 0;
            xMax = 0;
            yMin = 0;
            yMax = 0;
            rotVal = 0;
            _penUp = false;
            _penColor = 0x000000;
            graphics.clear();
            graphics.lineStyle(2, _penColor);
            draw();
        }

        public function beginFill(val:Number):void {
            graphics.beginFill(val);
        }

        public function endFill():void {
            graphics.endFill();
        }

        public function moveForward(val:Number):void {
            xVal += Math.cos(rad(rotVal)) * val;
            yVal += Math.sin(rad(rotVal)) * val;
            draw();
        }

        public function moveBackward(val:Number):void {
            xVal -= Math.cos(rad(rotVal)) * val;
            yVal -= Math.sin(rad(rotVal)) * val;
            draw();
        }

        public function turnRight(val:Number):void {
            rotVal += val % 360;
            draw();
        }

        public function turnLeft(val:Number):void {
            rotVal -= val % 360;
            draw();
        }

        public function snapshot():ImageSnapshot {
            clearTurtle();
            var m:Matrix = new Matrix();
            var w:Number = xMax - xMin;
            var h:Number = yMax - yMin;
            m.translate(-xMin + 5, -yMin + 5);
            var bitmapData:BitmapData = new BitmapData(w + 10, h + 10);
            bitmapData.draw(this, m);
            redrawTurtle();
            return ImageSnapshot.captureImage(bitmapData);
        }

        private function draw():void {
            if (penUp) {
                graphics.moveTo(xVal, yVal);
            } else {
                graphics.lineTo(xVal, yVal);
                xMax = Math.max(xVal, xMax);
                yMax = Math.max(yVal, yMax);
                xMin = Math.min(xVal, xMin);
                yMin = Math.min(yVal, yMin);
            }
            redrawTurtle();
        }

        private function clearTurtle():void {
            turtleCursor.graphics.clear();
        }

        private function redrawTurtle():void {
            turtleCursor.graphics.clear();
            if (!penUp) {
                turtleCursor.graphics.beginFill(penColor);
            }
            turtleCursor.graphics.lineStyle(2, penColor);
            turtleCursor.graphics.drawCircle(0, 0, 10);
            turtleCursor.graphics.drawCircle(14, 0, 4);
            turtleCursor.x = xVal;
            turtleCursor.y = yVal;
            turtleCursor.rotation = rotVal;
        }

        private static function rad(deg:int):Number {
            return deg * Math.PI / 180;
        }
    }
}
