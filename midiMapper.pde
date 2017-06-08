public enum midiType
{
  eModeBtn
  ,eSpeedKnob
  ,ePlayBtn
  ,eStopBtn
  ,eClearBtn
  ,eNextLamps
  ,ePrevLamps
  ,eUnknow
};
static class midiMapper
{
  public static midiType getType(int number)
  {
    if(number >= 32 && number < 39 || number >= 48 && number < 55 || number >= 64 && number < 71)
    {
      return midiType.eModeBtn;
    }
    else if(number == 16)
    {
      return midiType.eSpeedKnob;
    }
    else if(number == 41)
    {
      return midiType.ePlayBtn;
    }
    else if(number == 42)
    {
      return midiType.eStopBtn;
    }
    else if(number == 60)
    {
      return midiType.eClearBtn;
    }
    else if(number == 62)
    {
      return midiType.eNextLamps;
    }
    else if(number == 61)
    {
      return midiType.ePrevLamps;
    }
    else
    {
      return midiType.eUnknow;
    }
  }
  
  public static int getModeID(int number)
  {
    //0~7
    if(number >= 32 && number < 39)
    {
      return (number - 32);
    }
    //8~15
    else if(number >= 48 && number < 55)
    {
      return (number - 40);
    }
    //16~23
    else if(number >= 64 && number < 71)
    {
      return (number - 48);
    }
    else
    {
      return -1;
    }
  }
}