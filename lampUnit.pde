class lampUnit
{
  private PVector _start, _end;
  private Boolean _isOn;
  
  public lampUnit()
  {
    _isOn = false;
  }
  
  public lampUnit(PVector s, PVector e)
  {
    _isOn = false;
    _start = s;
    _end = e;
  }
  
  
  
  public void set(PVector s, PVector e)
  {
    _start = s;
    _end = e;
  }
  
  public void display()
  {
    stroke(255);
    line(_start.x, _start.y, _start.z, _end.x, _end.y, _end.z);
  }
  
  public void display(PGraphics pg, Boolean isSelect)
  {
    pushStyle();
    if(isSelect)
    {      
      pg.strokeWeight(5);
    }
    else
    {
      pg.strokeWeight(1);
    }
    
    if(_isOn)
    {
      pg.stroke(255);
    }
    else
    {
      pg.stroke(100);
    }
    pg.line(_start.x, _start.y, _start.z, _end.x, _end.y, _end.z);
    popStyle();
  }
  
  public void setOn()
  {
    _isOn = true;
  }
  
  public void setOff()
  {
    _isOn = false;
  }
  
}