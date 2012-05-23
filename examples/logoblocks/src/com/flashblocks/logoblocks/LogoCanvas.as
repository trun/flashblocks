package com.flashblocks.logoblocks {
    import mx.core.UIComponent;

    public class LogoCanvas extends UIComponent {
        private var xVal:Number;
        private var yVal:Number;
        private var rotVal:Number;
        private var _penUp:Boolean;
        private var _penColor:uint;

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
            rotVal = 0;
            _penUp = false;
            _penColor = 0x000000;
            graphics.clear();
            graphics.lineStyle(2, _penColor);
            draw();
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

        private function draw():void {
            if (penUp) {
                graphics.moveTo(xVal, yVal);
            } else {
                graphics.lineTo(xVal, yVal);
            }
            redrawTurtle();
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
