class bpmPad
{
  private boolean _isPlay, _isTrigger;
  private int _bpm;
  private float _beatTime;
  private float _linePrec, _lineSpeed, _beatPrec;
  private lampsState _padData;
  private int _beatIndex;
  private int _padWidth, _padHeight;
  private int _btnWidth, _btnHeight;

  //------------------------------
  bpmPad(int w, int h)
  {
    _isPlay = false;
    _padData = new lampsState(cLampNum, cBeatNum);

    _bpm = 120;
    _linePrec = 0.0f;
    _beatTime = bpmToBeatTime(_bpm);
    updateLineSpeed();

    _padWidth = w;
    _padHeight = h;
    _btnWidth = round( (_padWidth / cBeatNum));
    _btnHeight = round( (_padHeight / cLampNum));
  }

  //------------------------------
  public void update(float delta)
  {
    if (!_isPlay)
    {
      return;
    }
    _linePrec += _lineSpeed * delta;

    if (_linePrec >= 1.0)
    {
      _linePrec -= 1.0f;
    }

    int nowBeatIdx = floor(_linePrec / _beatPrec);
    if (_beatIndex != nowBeatIdx)
    {
      _isTrigger = true;
      _beatIndex = nowBeatIdx;
    }
  }

  //------------------------------
  public void display(PGraphics canvas)
  {

    canvas.pushMatrix();
    canvas.pushStyle();
    {
      //Pad
      displayPad(canvas);

      //Line

      int x = ceil(canvas.width * _linePrec);
      canvas.stroke(255);
      canvas.line(x, 0, x, canvas.height);
    }
    canvas.popStyle();
    canvas.popMatrix();
  }

  //------------------------------
  public void clear()
  {
    _padData.clear();
  }

  //------------------------------
  public lampsState getPadData()
  {
    return _padData;
  }

  //------------------------------
  public void setPadData(lampsState data)
  {
    _padData = (lampsState)data.clone();
  }

  //------------------------------
  public int getTriggerIndex()
  {
    if (_isPlay)
    {
      if (_isTrigger)
      {
        _isTrigger = false;
        return _beatIndex;
      } else
      {
        return -1;
      }
    } else
    {
      return -1;
    }
  }

  //------------------------------
  public int getBPM()
  {
    return _bpm;
  }

  //------------------------------
  public void play()
  {
    _isPlay = true;
    _isTrigger = true;
    _linePrec = 0.0f;
    _beatIndex = 0;
    updateLineSpeed();
  }

  //------------------------------
  public void stop()
  {
    _isPlay = false;
    _isTrigger = false;
    _linePrec = 0.0f;
    updateLineSpeed();
  }

  //------------------------------
  public void setBPM(int value)
  {
    _bpm = max(min(value, 400), 0);
    _beatTime = bpmToBeatTime(_bpm);
    updateLineSpeed();
  }

  //------------------------------
  public void add()
  {
    _bpm = min(_bpm + 1, 400);
    _beatTime = bpmToBeatTime(_bpm);
    updateLineSpeed();
  }

  //------------------------------
  public void sub()
  {
    _bpm = max(_bpm - 1, 0);
    _beatTime = bpmToBeatTime(_bpm);
    updateLineSpeed();
  }

  //------------------------------
  public boolean mouseRelease(int x, int y, int[] lampIdx, int[] beatIdx)
  {
    beatIdx[0] = floor(x / _btnWidth);
    lampIdx[0] = floor(y / _btnHeight);

    _padData.flip(lampIdx[0], beatIdx[0]);

    return _padData.get(lampIdx[0], beatIdx[0]);
  }

  //------------------------------
  private void displayPad(PGraphics canvas)
  {
    canvas.pushStyle();
    {
      canvas.strokeWeight(2);

      canvas.rect(0, 0, canvas.width, canvas.height);

      for (int lampIdx = 0; lampIdx < cLampNum; lampIdx++)
      {
        int posY = lampIdx * (_btnHeight);
        for (int beatIdx = 0; beatIdx < cBeatNum; beatIdx++)
        {
          int posX = beatIdx * (_btnWidth);
          if (_padData.get(lampIdx, beatIdx))
          {
            canvas.fill(200);
          } else
          {
            canvas.fill(50);
          }

          canvas.rect(posX, posY, _btnWidth, _btnHeight);

          canvas.noFill();
          canvas.stroke(0);
          canvas.rect(posX, posY, _btnWidth, _btnHeight);
        }
      }
    }
    canvas.popStyle();
  }

  //------------------------------
  private void updateLineSpeed()
  {
    _beatPrec = (1.0 / cBeatNum);
    _lineSpeed = _beatPrec / _beatTime;
  }

  //------------------------------
  private float bpmToBeatTime(int bpm)
  {
    return 60.0 / bpm;
  }
}