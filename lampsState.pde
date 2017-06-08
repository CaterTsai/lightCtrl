
class lampsState
{
  private boolean[][] _data;

  lampsState(int y, int x)
  {
    _data = new boolean[y][x];
    for (int i = 0; i < y; i++)
    {
      _data[i] = new boolean[x];
    }
  }

  void set(int y, int x, boolean val)
  {
    _data[y][x] = val;
  }

  boolean get(int y, int x)
  {
    return _data[y][x];
  }

  void flip(int y, int x)
  {
    _data[y][x] ^= true;
  }

  void clear()
  {
    for (int lampIdx = 0; lampIdx < cLampNum; lampIdx++)
    {
      for (int beatIdx = 0; beatIdx < cBeatNum; beatIdx++)
      {
        _data[lampIdx][beatIdx] = false;
      }
    }
  }

  public lampsState clone() 
  {
    lampsState copyObj = new lampsState(cLampNum, cBeatNum);
    for (int lampIdx = 0; lampIdx < cLampNum; lampIdx++)
    {
      for (int beatIdx = 0; beatIdx < cBeatNum; beatIdx++)
      {
        copyObj.set(lampIdx, beatIdx, _data[lampIdx][beatIdx]);
      }
    }
    return copyObj;
  }
}