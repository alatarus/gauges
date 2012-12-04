package alatarus.layouts
{
	import flash.geom.Matrix;
	
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class EllipticalLayout extends LayoutBase
	{
		private static const TO_RADIAN:Number = Math.PI / 180;
		
		public static const INSIDE:String = 'inside';
		public static const OUTSIDE:String = 'outside';
		public static const CENTER:String = 'center';
		
		public function EllipticalLayout()
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
			_startAngle = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _endAngle:Number = 360;
		
		
		public function get endAngle():Number
		{
			return _endAngle;
		}
		
		public function set endAngle(value:Number):void
		{
			_endAngle = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _rotateElements:Boolean = false;
		
		[Inspectable(type="Boolean", defaultValue="false")]
		public function set rotateElements(value:Boolean):void
		{
			_rotateElements = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		public function get rotateElements():Boolean
		{
			return _rotateElements;
		}
		
		private var _align:String = CENTER;
		
		[Inspectable(enumeration="outside,inside,center", defaultValue="center")]
		public function set align(value:String):void
		{
			_align = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		public function get align():String
		{
			return _align;
		}
		
		private function invalidateTargetSizeAndDisplayList():void
		{
			var g:GroupBase = target;
			if (!g)
				return;
			
			g.invalidateSize();
			g.invalidateDisplayList();
		}
		
		override public function updateDisplayList(width:Number, height:Number):void
		{
			var layoutTarget:GroupBase = target;
			var count:int = layoutTarget.numElements;
			
			// The position for the current element
			var radiusX:Number = width * .5;
			var radiusY:Number = height * .5;
			var x:Number = 0;
			var y:Number = 0;
			var stepAngle:Number = (startAngle - endAngle) / (count - 1);
			var angle:Number;
			
			var matrix:Matrix;
			
			var element:ILayoutElement;
			var elementWidth:Number;
			var elementHeight:Number;
			
			// loop through the elements
			for (var i:int = 0; i < count; i++)
			{
				matrix = new Matrix();
				element = useVirtualLayout ? layoutTarget.getVirtualElementAt(i) : layoutTarget.getElementAt(i);
				
				if (!element.includeInLayout)
					continue;
				
				// Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(NaN, NaN);
				element.setLayoutMatrix(matrix, false);
				
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				elementWidth = element.getLayoutBoundsWidth();
				elementHeight = element.getLayoutBoundsHeight();
				
				angle = (startAngle - stepAngle * i) * TO_RADIAN;
				
				x = Math.round(radiusX * Math.cos(angle) + radiusX);
				y = Math.round(radiusY * Math.sin(angle) + radiusY);
				
				var translateX:Number;
				var translateY:Number;
				
				switch (align)
				{
					case OUTSIDE:
						translateX = rotateElements ? 0 : -elementWidth * roundTranslateOffcet(1 - x / width);
						translateY = rotateElements ? -elementHeight * .5 : -elementHeight * roundTranslateOffcet(1 - y / height);
						break;
					case INSIDE:
						translateX = rotateElements ? -elementWidth : -elementWidth * roundTranslateOffcet(x / width);
						translateY = rotateElements ? -elementHeight * .5 : -elementHeight * roundTranslateOffcet(y / height);
						break;
					default:
						translateX = -elementWidth * .5;
						translateY = -elementHeight * .5;
				}
				
				matrix.translate(Math.round(translateX), Math.round(translateY));
				
				//Rotate elment if needed
				if (rotateElements)
				{
					var rotateAngle:Number = Math.atan2(y - radiusY, x - radiusX);
					
					
					matrix.rotate(rotateAngle);
				}
				
				matrix.translate(x, y);
				
				element.setLayoutMatrix(matrix, false);
			}
		}
		
		private function roundTranslateOffcet(value:Number):Number
		{
			if (value < 0.48)
				return 0;
			else if (value > 0.52)
				return 1;
			
			return .5;
		}
	}
}