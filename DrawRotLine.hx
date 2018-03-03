import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawRotLine {

	public static function getCoordinate(z:Bool, s:Float, a:Float, r:Float) {
		if (z) {
			return s + (r * Math.cos(a * Utils.RAD));
		} else {
			return s + (r * Math.sin(a * Utils.RAD));
		}
	}

	public static function drawLine(g:G, x:Float, y:Float, a:Float, r:Float) {
		g.drawLine(x, y, getCoordinate(true, x, a, r), getCoordinate(false, y, a, r));
	}
}