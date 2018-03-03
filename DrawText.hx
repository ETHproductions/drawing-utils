import com.stencyl.graphics.G;
import com.stencyl.utils.Utils;
import com.stencyl.models.Scene;
import com.stencyl.Engine;

class DrawText {

	public static function drawText(g:G, text:Dynamic, align:String, x:Float, y:Float) {
		if (align == "l") {
			g.drawString("" + text, x, y);
		} else if (align == "c") {
			g.drawString("" + text, x - ((g.font.font.getTextWidth("" + text) / Engine.SCALE) / 2), y);
		} else if (align == "r") {
			g.drawString("" + text, x - (g.font.font.getTextWidth("" + text) / Engine.SCALE), y);
		} else {
			g.drawString("" + text, x, y);
		}
	}
}