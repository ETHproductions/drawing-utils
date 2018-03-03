import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawPolygons {

	public static function drawPolygon(g:G, d:Bool, x:Float, y:Float, s:Int, r:Float, a:Float) {
		var tempx:Float;
		var tempy:Float;
		if (d) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...s) {
			tempx = x + (r * Math.cos((a + (i * (360 / s))) * Utils.RAD));
			tempy = y + (r * Math.sin((a + (i * (360 / s))) * Utils.RAD));
			g.addPointToPolygon(tempx, tempy);
		}
		g.endDrawingPolygon();
	}

	public static function drawStar(g:G, d:Bool, x:Float, y:Float, s:Int, r1:Float, r2: Float, a:Float) {
		var tempx:Float;
		var tempy:Float;
		var s2:Int = s * 2;
		if (r2 < r1) {
			var temp:Float = r1;
			r1 = r2;
			r2 = temp;
		}
		if (d) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...s2) {
			if (i % 2 == 0) {
				tempx = x + (r2 * Math.cos((a + (i * (360 / s2))) * Utils.RAD));
				tempy = y + (r2 * Math.sin((a + (i * (360 / s2))) * Utils.RAD));
			} else {
				tempx = x + (r1 * Math.cos((a + (i * (360 / s2))) * Utils.RAD));
				tempy = y + (r1 * Math.sin((a + (i * (360 / s2))) * Utils.RAD));
			}
			g.addPointToPolygon(tempx, tempy);
		}
		g.endDrawingPolygon();
	}
}