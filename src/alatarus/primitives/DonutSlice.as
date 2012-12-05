package alatarus.primitives
{
    import flash.display.Graphics;
    
    import spark.primitives.supportClasses.FilledElement;

    public class DonutSlice extends FilledElement implements ISlice
    {
        public function DonutSlice()
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

        private var _weight:Number = 10;

        public function get weight():Number
        {
            return _weight;
        }

        public function set weight(value:Number):void
        {
            if (_weight == value)
                return;

            _weight = value;
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

            var tempStartX:Number = startX;
            var tempStartY:Number = startY;

            var segmentAngle:Number = (endAngle - startAngle) / 4;
            var angle:Number;

            g.moveTo(startX, startY);

            var i:int;

            for (i = 1; i < 5; i++)
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

            radiusX -= weight;
            radiusY -= weight;
            startX = radiusX * Math.cos(endAngle * toRadian) + centerX;
            startY = radiusY * Math.sin(endAngle * toRadian) + centerY;

            g.lineTo(startX, startY);

            for (i = 3; i > -1; i--)
            {
                angle = (segmentAngle * i + startAngle) * toRadian;

                endX = radiusX * Math.cos(angle) + centerX;
                endY = radiusY * Math.sin(angle) + centerY;
                middleX = radiusX * Math.cos(angle + segmentAngle * toRadian * .5) + centerX;
                middleY = radiusY * Math.sin(angle + segmentAngle * toRadian * .5) + centerY;
                controlX = 2 * middleX - (startX + endX) * .5;
                controlY = 2 * middleY - (startY + endY) * .5;
                g.curveTo(controlX, controlY, endX, endY);

                g.lineTo(endX, endY);

                startX = endX;
                startY = endY;
            }

            g.lineTo(tempStartX, tempStartY);
        }
    }
}
