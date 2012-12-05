package alatarus.primitives
{
	import spark.core.IGraphicElement;
	
	public interface ISlice extends IGraphicElement
	{
		function get startAngle():Number;
		function set startAngle(value:Number):void;
		
		function get endAngle():Number;
		function set endAngle(value:Number):void;
	}
}