import java.util.*;


class lampsModeMgr
{
  private List<lampsState[]> _manager = new ArrayList<lampsState[]>();
  private Map<String, Integer> _keyIndex = new HashMap<String, Integer>();
  
  lampsModeMgr()
  {}
  
  public lampsState[] getLampsState(int id)
  {
    return _manager.get(id);
  }
  
  public int getModeNum()
  {
    return _manager.size();
  }
  
  public String getModeName(int id)
  {
    String name = "unknow";
    for(Object key : _keyIndex.keySet())
    {
      if(_keyIndex.get(key) == id)
      {
        name = key.toString();
        break;
      }
    }
    return name;
  }
  
  //----------------------------------------
  public void addByJson(String name, JSONObject json)
  {
    boolean isFormatCorrent = true;
    lampsState[] lampsState = new lampsState[4];
    
    for(int i = 0; i < 4; i++)
    {
      lampsState[i] = new lampsState(cLampNum, cBeatNum);
      JSONArray lampData = json.getJSONArray(Integer.toString(i)); 
      if(lampData.size() != cLampNum)
      {
        isFormatCorrent = false;
        break;
      }
      for(int lampIdx = 0; lampIdx < cLampNum; lampIdx++)
      {
        JSONArray beatData = lampData.getJSONArray(lampIdx);
        if(beatData.size() != cBeatNum)
        {
          isFormatCorrent = false;
          break;
        }
        for(int beatIdx = 0; beatIdx < cBeatNum; beatIdx++)
        {
          lampsState[i].set(lampIdx, beatIdx, beatData.getBoolean(beatIdx));
        }
      }
    }
    
    if(isFormatCorrent)
    {
      _manager.add(lampsState);
      _keyIndex.put(name, _manager.size() - 1);
    }
    else
    {
      println("json file wrong format. file name : " + name);
    }
  }
  
  //----------------------------------------
  public void displayNameList(int x, int y)
  {
    pushMatrix();
    pushStyle();
    translate(x, y);
    fill(100);
    rect(0, 0, cModeDisplayWidth, 40 + _manager.size() * 25);
    
    fill(255);
    textSize(16);
    text("Mode List:", 0, 20);
    
    text("(0):Free", 0, 40);
    for(Object key : _keyIndex.keySet())
    {
      int index_ = _keyIndex.get(key);
      text("(" + Integer.toString(index_ + 1) + "):" + key.toString() , 0, index_ * 20 + 60);
    }
    
    
    popStyle();
    popMatrix();
  }
}