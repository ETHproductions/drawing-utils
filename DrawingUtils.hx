import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;
import com.stencyl.Engine;

class DrawingUtils {
	
	public static function getXCoordinate(x:Float, a:Float, r:Float):Float {
		return x + (r * Math.cos(a * Utils.RAD));
	}
	public static function getYCoordinate(y:Float, a:Float, r:Float):Float {
		return y + (r * Math.sin(a * Utils.RAD));
	}
	
	public static function beginPoly(g:G, fill:Bool):Void {
		if (fill) {
			g.beginFillPolygon();
		} else {
			g.beginDrawPolygon();
		}
	}
	
	public static function addPoint(g:G, x:Float, y:Float, a:Float, r:Float):Void {
		g.addPointToPolygon(
			getXCoordinate(x, a, r),
			getYCoordinate(y, a, r)
		);
	}

	public static function drawLine(g:G, x:Float, y:Float, a:Float, r:Float):Void {
		g.drawLine(x, y, getXCoordinate(x, a, r), getYCoordinate(y, a, r));
	}
	
	public static function drawRotatedRect(g:G, fill:Bool, centerX:Float, centerY:Float, width:Float, height:Float, angle:Float):Void {
		// First, define some basics...
		var left:Float = centerX - Math.abs(width / 2);
		var top:Float = centerY - Math.abs(height / 2);

		// Now find the angles. (Utils is a treasure trove of code!)
		var currAngle:Float = Utils.angle(centerX, centerY, left, top);
		var radius:Float = Utils.distance(centerX, centerY, left, top);

		// Finally, draw the new rectangle.
		beginPoly(g, fill);
		for (i in 0...4) {
			addPoint(g, centerX, centerY, currAngle + angle, radius);
			currAngle = (i % 2 == 1) ? -currAngle : -currAngle - 180;
		}
		g.endDrawingPolygon();
	}
	
	public static function drawPolygon(g:G, fill:Bool, x:Float, y:Float, s:Int, r:Float, a:Float):Void {
		beginPoly(g, fill);
		for (i in 0...s) {
			addPoint(g, x, y, a, r);
			a += 360 / s;
		}
		g.endDrawingPolygon();
	}

	public static function drawStar(g:G, fill:Bool, x:Float, y:Float, s:Int, r1:Float, r2: Float, a:Float):Void {
		if (r2 < r1) {
			var temp:Float = r1;
			r1 = r2;
			r2 = temp;
		}
		beginPoly(g, fill);
		for (i in 0...s*2) {
			addPoint(g, x, y, a, i % 2 == 0 ? r2 : r1);
			a += 360 / (s*2);
		}
		g.endDrawingPolygon();
	}
	
	public static function drawArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var tempx1:Float, tempy1:Float, tempx2:Float, tempy2:Float;
		if (s > e) {
			var temp:Float = s;
			s = e;
			e = temp;
		}
		e = s + Math.min(e - s, 360);
		tempx1 = getXCoordinate(x, s, r);
		tempy1 = getYCoordinate(y, s, r);
		while (++s < e) {
			tempx2 = getXCoordinate(x, s, r);
			tempy2 = getYCoordinate(y, s, r);
			g.drawLine(tempx1, tempy1, tempx2, tempy2);
			tempx1 = tempx2;
			tempy1 = tempy2;
		}
		tempx2 = getXCoordinate(x, e, r);
		tempy2 = getYCoordinate(y, e, r);
		g.drawLine(tempx1, tempy1, tempx2, tempy2);
	}
	
	public static function addArc(g:G, x:Float, y:Float, s:Float, e:Float, r:Float) {
		var swap:Bool = e < s;
		e = Math.abs(e - s) > 360 ? s + 360 : e;
		
		while (swap ? (s - 1 > e) : (s + 1 < e)) {
			addPoint(g, x, y, s, r);
			swap ? --s : ++s;
		}
		addPoint(g, x, y, e, r);
	}

	public static function drawWedge(g:G, fill:Bool, wedge:Bool, x:Float, y:Float, s:Float, e:Float, r:Float) {
		beginPoly(g, fill);
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
			beginPoly(g, fill);
			addArc(g, x, y, 0, 360, Math.abs(r1));
			addArc(g, x, y, 360, 0, Math.abs(r2));
			g.endDrawingPolygon();
			g.strokeSize = stroke;
			g.drawCircle(x, y, Math.abs(r1));
			g.drawCircle(x, y, Math.abs(r2));
		} else {
			beginPoly(g, fill);
			addArc(g, x, y, s, e, Math.abs(r1));
			addArc(g, x, y, e, s, Math.abs(r2));
			g.endDrawingPolygon();
		}
	}

	public static function drawEllipse(g:G, fill:Bool, x:Float, y:Float, w:Float, h:Float, a:Float) {
		var tempx:Float, tempy:Float;
		w = Math.abs(w);
		h = Math.abs(h);
		
		if (w == 0 || h == 0)
			return;
		
		var points:Float = Math.min(Math.round(Math.sqrt(w*w + h*h) * 0.25) + 10, 360);

		beginPoly(g, fill);
		var i:Float = 0;
		while (i < 360) {
			tempx = getXCoordinate(0, i, w/2);
			tempy = getYCoordinate(0, i, h/2);
			addPoint(g, x, y, Utils.angle(0, 0, tempx, tempy) + a, Utils.distance(0, 0, tempx, tempy));
			i += 360 / points;
		}
		g.endDrawingPolygon();
	}
	
	public static function drawBezierCurve(g:G, x1:Float, y1:Float, x2:Float, y2:Float, adjust:Bool, xc:Float, yc:Float):Void {
		if (adjust) {
			xc = 2 * xc - (x1 + x2) / 2;
			yc = 2 * yc - (y1 + y2) / 2;
		}
		var points:Int = Std.int(Math.round((Utils.distance(x1, y1, xc, yc) + Utils.distance(x2, y2, xc, yc)) * 0.05) + 10);
		var tempx1:Float, tempy1:Float;
		var tempx2:Float = x1;
		var tempy2:Float = y1;
		var t0:Float = 0, t1:Float = 1;
		var i:Int = 0;
		while (i < points) {
			i++;
			t0 = i / points;
			t1 = 1 - t0;
			tempx1 = tempx2;
			tempy1 = tempy2;
			tempx2 = t1 * ((xc * t0) + (x1 * t1)) + t0 * ((x2 * t0) + (xc * t1));
			tempy2 = t1 * ((yc * t0) + (y1 * t1)) + t0 * ((y2 * t0) + (yc * t1));
			g.drawLine(tempx1, tempy1, tempx2, tempy2);
		}
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
	
	public static function drawText(g:G, text:Dynamic, align:String, x:Float, y:Float) {
		if (align == "r") {
			g.drawString("" + text, x - (g.font.font.getTextWidth("" + text) / Engine.SCALE), y);
		} else if (align == "c") {
			g.drawString("" + text, x - (g.font.font.getTextWidth("" + text) / Engine.SCALE / 2), y);
		} else {
			g.drawString("" + text, x, y);
		}
	}
}