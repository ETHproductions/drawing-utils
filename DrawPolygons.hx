import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawPolygons {
	
	public static function drawPolygon(g:G, fill:Bool, x:Float, y:Float, s:Int, r:Float, a:Float):Void {
		var tempx:Float, tempy:Float;
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...s) {
			tempx = DrawRotLine.getCoordinate(true, x, a, r);
			tempy = DrawRotLine.getCoordinate(false, y, a, r);
			g.addPointToPolygon(tempx, tempy);
			a += 360 / s;
		}
		g.endDrawingPolygon();
	}

	public static function drawStar(g:G, fill:Bool, x:Float, y:Float, s:Int, r1:Float, r2: Float, a:Float):Void {
		var tempx:Float, tempy:Float, tempr:Float;
		if (r2 < r1) {
			var temp:Float = r1;
			r1 = r2;
			r2 = temp;
		}
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...s*2) {
			tempr = i % 2 == 0 ? r2 : r1;
			tempx = DrawRotLine.getCoordinate(true, x, a, tempr);
			tempy = DrawRotLine.getCoordinate(false, y, a, tempr);
			g.addPointToPolygon(tempx, tempy);
			a += 360 / (s*2);
		}
		g.endDrawingPolygon();
	}
}