import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;

class DrawCircles {

	public static function drawArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var tempx1:Float;
		var tempy1:Float;
		var tempx2:Float;
		var tempy2:Float;
		while (s < -180) { s += 360; e += 360; }
		while (s > 540) { s -= 360; e -= 360; }
		while (e < -180) { e += 360; }
		while (e > 540) { e -= 360; }
		if (s % 1 != 0) {
			tempx1 = x + (r * Math.cos(s * Utils.RAD));
			tempy1 = y + (r * Math.sin(s * Utils.RAD));
			tempx2 = x + (r * Math.cos(Math.ceil(s) * Utils.RAD));
			tempy2 = y + (r * Math.sin(Math.ceil(s) * Utils.RAD));
			g.drawLine(tempx1, tempy1, tempx2, tempy2);
		}
		for (i in -180...540) {
			if ((s <= i) && (i + 1 <= e)) {
				tempx1 = x + (r * Math.cos(i * Utils.RAD));
				tempy1 = y + (r * Math.sin(i * Utils.RAD));
				tempx2 = x + (r * Math.cos((i + 1) * Utils.RAD));
				tempy2 = y + (r * Math.sin((i + 1) * Utils.RAD));
				g.drawLine(tempx1, tempy1, tempx2, tempy2);
			}
		}
		if (e % 1 != 0) {
			tempx1 = x + (r * Math.cos(Math.floor(e) * Utils.RAD));
			tempy1 = y + (r * Math.sin(Math.floor(e) * Utils.RAD));
			tempx2 = x + (r * Math.cos(e * Utils.RAD));
			tempy2 = y + (r * Math.sin(e * Utils.RAD));
			g.drawLine(tempx1, tempy1, tempx2, tempy2);
		}
	}

	public static function addArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var tempx:Float;
		var tempy:Float;
		while (e < -180) { s += 360; e += 360; }
		while (e > 540) { s -= 360; e -= 360; }
		while (s < -180) { s += 360; e += 360; }
		while (s > 540) { s -= 360; e -= 360; }
		if (s - e >= 360) { s = 360; e = 0; }
		else if (e - s >= 360) { s = 0; e = 360; }
		if (s % 1 != 0) {
			tempx = x + (r * Math.cos(s * Utils.RAD));
			tempy = y + (r * Math.sin(s * Utils.RAD));
			g.addPointToPolygon(tempx, tempy);
		}
		if (s <= e) {
			for (i in -180...540) {
				if ((s <= i) && (i <= e)) {
					tempx = x + (r * Math.cos(i * Utils.RAD));
					tempy = y + (r * Math.sin(i * Utils.RAD));
					g.addPointToPolygon(tempx, tempy);
				}
			}
		} else {
			for (i in -180...540) {
				if ((e <= 360 - i) && (360 - i <= s)) {
					tempx = x + (r * Math.cos((360 - i) * Utils.RAD));
					tempy = y + (r * Math.sin((360 - i) * Utils.RAD));
					g.addPointToPolygon(tempx, tempy);
				}
			}
		}
		if (e % 1 != 0) {
			tempx = x + (r * Math.cos(e * Utils.RAD));
			tempy = y + (r * Math.sin(e * Utils.RAD));
			g.addPointToPolygon(tempx, tempy);
		}
	}

	public static function drawWedge(g:G, fill:Bool, w:Bool, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var temp:Float;
		if (s > e) {
			temp = s;
			s = e;
			e = temp;
		}
		while (s < -180) { s += 360; e += 360; }
		while (s > 540) { s -= 360; e -= 360; }
		while (e < -180) { e += 360; }
		while (e > 540) { e -= 360; }
		if (s > e) {
			temp = s;
			s = e;
			e = temp;
		}
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		addArc(g, x, y, s, e, r);
		if (w && Math.abs(e - s) <= 360) {
			g.addPointToPolygon(x, y);
		}
		g.endDrawingPolygon();
	}

	public static function drawRing(g:G, fill:Bool, x:Float, y:Float, s:Float, e:Float, r1:Float, r2:Float) {
		var stroke:Int = 0;
		if (Math.abs(s - e) >= 360) {
			stroke = g.strokeSize;
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
		var tempx:Float;
		var tempy:Float;
		var templ:Float;
		var tempa:Float;
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
			tempx = w * Math.cos(i * Utils.RAD);
			tempy = h * Math.sin(i * Utils.RAD);
			templ = Utils.distance(0, 0, tempx, tempy);
			tempa = a + Utils.angle(0, 0, tempx, tempy);
			tempx = x + (templ * Math.cos(tempa * Utils.RAD));
			tempy = y + (templ * Math.sin(tempa * Utils.RAD));
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

	public static function drawPeanut(g:G, fill:Bool, x:Float, y:Float, w:Float, h:Float, a:Float) {
		var tempx:Float;
		var tempy:Float;
		var templ:Float;

		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
		for (i in 0...360) {
			tempx = w * Math.cos(i * Utils.RAD);
			tempy = h * Math.sin(i * Utils.RAD);
			templ = Math.sqrt((tempx * tempx) + (tempy * tempy));
			tempx = DrawRotLine.getCoordinate(true, x, a + i, templ);
			tempy = DrawRotLine.getCoordinate(false, y, a + i, templ);
			g.addPointToPolygon(tempx, tempy);
		}
		g.endDrawingPolygon();
	}
}