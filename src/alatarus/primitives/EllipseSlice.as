package alatarus.primitives
{
    import flash.display.Graphics;
    
    import spark.primitives.supportClasses.FilledElement;

    public class EllipseSlice extends FilledElement implements ISlice
    {
        public function EllipseSlice()
        {
            super();
        }

        private var _startAngle:Number = 0;

        public function get startAngle():Number
        {
            return _startAngle;
        }

        public function set startAngle(value:Number):void
        {
            if (_startAngle == value)
                return;

            _startAngle = value;
            invalidateDisplayList();
        }

        private var _endAngle:Number = 180;


        public function get endAngle():Number
        {
            return _endAngle;
        }

        public function set endAngle(value:Number):void
        {
            if (_endAngle == value)
                return;

            _endAngle = value;
            invalidateDisplayList();
        }

        override protected function draw(g:Graphics):void
        {
            if ((endAngle - startAngle) == 0)
                return;

			const toRadian:Number = Math.PI / 180;
			
            var middleX:Number;
            var middleY:Number;
            var endX:Number;
            var endY:Number;
            var controlX:Number;
            var controlY:Number;
            var radiusX:Number = width * .5;
            var radiusY:Number = height * .5;
            var centerX:Number = radiusX + drawX;
            var centerY:Number = radiusY + drawY;
            var startX:Number = radiusX * Math.cos(startAngle * toRadian) + centerX;
            var startY:Number = radiusY * Math.sin(startAngle * toRadian) + centerY;
            var segmentAngle:Number = (endAngle - startAngle) / 4;
            var angle:Number;

            g.moveTo(centerX, centerY);
            g.lineTo(startX, startY);

            for (var i:int = 1; i < 5; i++)
            {
                angle = (segmentAngle * i + startAngle) * toRadian;

                endX = radiusX * Math.cos(angle) + centerX;
                endY = radiusY * Math.sin(angle) + centerY;
                middleX = radiusX * Math.cos(angle - segmentAngle * toRadian * .5) + centerX;
                middleY = radiusY * Math.sin(angle - segmentAngle * toRadian * .5) + centerY;
                controlX = 2 * middleX - (startX + endX) * .5;
                controlY = 2 * middleY - (startY + endY) * .5;
                g.curveTo(controlX, controlY, endX, endY);

                startX = endX;
                startY = endY;
            }

            g.lineTo(centerX, centerY);
        }
    }
}
