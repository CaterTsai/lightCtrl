

class lampStruct
{
  private lampUnit[] _lamps;
  private lampsState _lampsState = new lampsState(cLampNum, cBeatNum);

  lampStruct(int size)
  {
    initLampObject(size);
  }

  //------------------------------
  public void draw(PGraphics canvas, PVector pos, Boolean isSelect)
  {
    _lampCanvas.pushMatrix();
    _lampCanvas.translate(pos.x, pos.y, pos.z);
    _lampCanvas.rotateX(-PI/4.0);
    _lampCanvas.rotateY(-PI/4.0);

    for (int i = 0; i < cLampNum; i++)
    {
      _lamps[i].display(canvas, isSelect);
    }
    _lampCanvas.popMatrix();
  }
  
  //------------------------------
  public void clear()
  {
    _lampsState.clear();
  }
  
  //------------------------------
  public void updateState(int beatIndex)
  {
    for(int i = 0; i < cLampNum; i++)
    {
      if(_lampsState.get(i, beatIndex))
      {
        _lamps[i].setOn();
      }
      else
      {
        _lamps[i].setOff();
      }
    }
  }

  //------------------------------
  public lampsState getLampState()
  {
    return _lampsState;
  }
  
  //------------------------------
  public boolean getLampState(int lampIndex, int beatIndex)
  {
    return _lampsState.get(lampIndex, beatIndex);
  }

  //------------------------------
  public void setLampState(lampsState newLampState)
  {
    _lampsState = newLampState.clone();
  }
  
  //------------------------------
  public void setLampState(int lampIndex, int beatIndex, boolean isOn)
  {
    _lampsState.set(lampIndex, beatIndex, isOn);
  }

  //------------------------------
  private void initLampObject(int size)
  {
    _lamps = new lampUnit[cLampNum];
    int halfSize = ceil(size * 0.5);
    PVector p1 = new PVector(halfSize * -1, halfSize * -1, halfSize * -1);
    PVector p2 = new PVector(halfSize * -1, halfSize * -1, halfSize * 1);
    PVector p3 = new PVector(halfSize * -1, halfSize * 1, halfSize * 1);
    PVector p4 = new PVector(halfSize * 1, halfSize * 1, halfSize * 1);
    PVector p5 = new PVector(halfSize * 1, halfSize * 1, halfSize * -1);
    PVector p6 = new PVector(halfSize * 1, halfSize * -1, halfSize * -1);
    PVector p7 = new PVector(halfSize * -1, halfSize * 1, halfSize * -1);

    _lamps[0] = new lampUnit(p1, p2);
    _lamps[1] = new lampUnit(p2, p3);
    _lamps[2] = new lampUnit(p3, p4);
    _lamps[3] = new lampUnit(p4, p5);
    _lamps[4] = new lampUnit(p5, p6);
    _lamps[5] = new lampUnit(p6, p1);
    _lamps[6] = new lampUnit(p1, p7);
    _lamps[7] = new lampUnit(p3, p7);
    _lamps[8] = new lampUnit(p5, p7);
  }

}