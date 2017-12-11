
package taglib;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 * A simple loop tag.
 */
public class LoopTag extends BodyTagSupport
{
	private int count;
	private int pos;

	public void setCount(int count)
	{
		this.count = count;
	}

        public int doStartTag()
	{
		if(count > 0)
	          return EVAL_BODY_TAG;
		else
		  return SKIP_BODY;
        }

	public int doAfterBody() throws JspException
	{
		// Iterate until the count's up
		if(++pos < count)
	        return EVAL_BODY_TAG;
		else
			return SKIP_BODY;
    }
	
	public int doEndTag() throws JspException
	{
		pos = 0;

		try
		{
			if(bodyContent != null) // Check if we even entered the body
				bodyContent.writeOut(bodyContent.getEnclosingWriter());
		}
		catch(java.io.IOException e)
		{
			throw new JspException("IO Error: " + e.getMessage());
		}
		
		return EVAL_PAGE;
	}
}
