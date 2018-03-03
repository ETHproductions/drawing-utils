import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawRotRect {

	public static function drawRotatedRect(g:G, fill:Bool, centerX:Float, centerY:Float, width:Float, height:Float, angle:Float) {
		// First, define some basics...
		var x1:Float = centerX - (width / 2);
		var y1:Float = centerY - (height / 2);
		var x2:Float = centerX + (width / 2);
		var y2:Float = centerY + (height / 2);

		// Now find the angles. (Utils is a treasure trove of code!)
		var angle1:Float = Utils.angle(centerX, centerY, x1, y1);
		var angle2:Float = Utils.angle(centerX, centerY, x2, y1);
		var angle3:Float = Utils.angle(centerX, centerY, x2, y2);
		var angle4:Float = Utils.angle(centerX, centerY, x1, y2);
		var radius:Float = Utils.distance(centerX, centerY, x1, y1);

		// Adjust the angles...
		angle1 = angle1 + angle;
		angle2 = angle2 + angle;
		angle3 = angle3 + angle;
		angle4 = angle4 + angle;

		// Finally, draw the new rectangle.
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		g.addPointToPolygon(DrawRotLine.getCoordinate(true, centerX, angle1, radius), DrawRotLine.getCoordinate(false, centerY, angle1, radius));
		g.addPointToPolygon(DrawRotLine.getCoordinate(true, centerX, angle2, radius), DrawRotLine.getCoordinate(false, centerY, angle2, radius));
		g.addPointToPolygon(DrawRotLine.getCoordinate(true, centerX, angle3, radius), DrawRotLine.getCoordinate(false, centerY, angle3, radius));
		g.addPointToPolygon(DrawRotLine.getCoordinate(true, centerX, angle4, radius), DrawRotLine.getCoordinate(false, centerY, angle4, radius));
		g.endDrawingPolygon();
	}
}