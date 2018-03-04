import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawCircles {

	public static function drawArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var tempx1:Float, tempy1:Float, tempx2:Float, tempy2:Float;
		if (s > e) {
			var temp:Float = s;
			s = e;
			e = temp;
		}
		e = s + Math.min(e - s, 360);
		tempx1 = DrawRotLine.getCoordinate(true, x, s, r);
		tempy1 = DrawRotLine.getCoordinate(false, y, s, r);
		while (++s < e) {
			tempx2 = DrawRotLine.getCoordinate(true, x, s, r);
			tempy2 = DrawRotLine.getCoordinate(false, y, s, r);
			g.drawLine(tempx1, tempy1, tempx2, tempy2);
			tempx1 = tempx2;
			tempy1 = tempy2;
		}
		tempx2 = DrawRotLine.getCoordinate(true, x, e, r);
		tempy2 = DrawRotLine.getCoordinate(false, y, e, r);
		g.drawLine(tempx1, tempy1, tempx2, tempy2);
	}
	
	public static function addArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var tempx1:Float, tempy1:Float;
		var swap:Bool = e < s;
		e = Math.abs(e - s) > 360 ? s + 360 : e;
		
		while (swap ? (s - 1 > e) : (s + 1 < e)) {
			tempx1 = DrawRotLine.getCoordinate(true, x, s, r);
			tempy1 = DrawRotLine.getCoordinate(false, y, s, r);
			g.addPointToPolygon(tempx1, tempy1);
			swap ? --s : ++s;
		}
		tempx1 = DrawRotLine.getCoordinate(true, x, e, r);
		tempy1 = DrawRotLine.getCoordinate(false, y, e, r);
		g.addPointToPolygon(tempx1, tempy1);
	}

	public static function drawWedge(g:G, fill:Bool, wedge:Bool, x:Float, y:Float, s:Float, e:Float, r:Float) {
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		addArc(g, x, y, s, e, r);
		if (wedge && Math.abs(e - s) <= 360) {
			g.addPointToPolygon(x, y);
		}
		g.endDrawingPolygon();
	}

	public static function drawRing(g:G, fill:Bool, x:Float, y:Float, s:Float, e:Float, r1:Float, r2:Float) {
		if (Math.abs(s - e) >= 360) {
			var stroke:Int = g.strokeSize;
			g.strokeSize = 0;
			if (fill) {
				g.beginFillPolygon();
			} else {
				g.beginDrawPolygon();
			}
			addArc(g, x, y, 0, 360, Math.abs(r1));
			addArc(g, x, y, 360, 0, Math.abs(r2));
			g.endDrawingPolygon();
			g.strokeSize = stroke;
			g.drawCircle(x, y, Math.abs(r1));
			g.drawCircle(x, y, Math.abs(r2));
		} else {
			if (fill) {
				g.beginFillPolygon();
			} else {
				g.beginDrawPolygon();
			}
			addArc(g, x, y, s, e, Math.abs(r1));
			addArc(g, x, y, e, s, Math.abs(r2));
			g.endDrawingPolygon();
		}
	}

	public static function drawEllipse(g:G, fill:Bool, x:Float, y:Float, w:Float, h:Float, a:Float) {
		var tempx:Float, tempy:Float;
		var templ:Float, tempa:Float;
		w = Math.abs(w);
		h = Math.abs(h);
		
		if (w == 0 || h == 0)
			return;
		
		var points:Float = Math.min(Math.round(Math.sqrt(w*w + h*h) * 0.25) + 10, 360);

		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		var i:Float = 0;
		while (i < 360) {
			tempx = DrawRotLine.getCoordinate(true, 0, i, w);
			tempy = DrawRotLine.getCoordinate(false, 0, i, h);
			templ = Utils.distance(0, 0, tempx, tempy);
			tempa = a + Utils.angle(0, 0, tempx, tempy);
			tempx = DrawRotLine.getCoordinate(true, x, tempa, templ);
			tempy = DrawRotLine.getCoordinate(false, y, tempa, templ);
			g.addPointToPolygon(tempx, tempy);
			i += 360 / points;
		}
		g.endDrawingPolygon();
	}

	public static function drawOrthoRect(g:G, fill:Bool, x:Float, y:Float, w:Float, h:Float) {
		w = Math.abs(w);
		h = Math.abs(h);
		x -= w / 2;
		y -= h / 2;
		if (fill) {
			g.fillRect(x, y, w, h);
		} else {
			g.drawRect(x, y, w, h);
		}
	}

	public static function drawOrthoEllipse(g:G, fill:Bool, x:Float, y:Float, w:Float, h:Float) {
		w = Math.abs(w);
		h = Math.abs(h);
		x -= w / 2;
		y -= h / 2;
		if (fill) {
			g.fillRoundRect(x, y, w, h, w + h);
		} else {
			g.drawRoundRect(x, y, w, h, w + h);
		}
	}
}