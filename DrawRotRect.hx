import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawRotRect {

	public static function drawRotatedRect(g:G, fill:Bool, centerX:Float, centerY:Float, width:Float, height:Float, angle:Float) {
		// First, define some basics...
		var left:Float = centerX - Math.abs(width / 2);
		var top:Float = centerY - Math.abs(height / 2);

		// Now find the angles. (Utils is a treasure trove of code!)
		var currAngle:Float = Utils.angle(centerX, centerY, left, top);
		var radius:Float = Utils.distance(centerX, centerY, left, top);

		// Finally, draw the new rectangle.
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...4) {
			g.addPointToPolygon(
				DrawRotLine.getCoordinate(true, centerX, currAngle + angle, radius),
				DrawRotLine.getCoordinate(false, centerY, currAngle + angle, radius)
			);
			currAngle = (i % 2 == 1) ? -currAngle : -currAngle - 180;
		}
		g.endDrawingPolygon();
	}
}