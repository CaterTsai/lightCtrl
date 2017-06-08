import themidibus.*;

//Const Parameter
static final int cBeatNum = 16;
static final int cLampNum = 9;
static final int cModeDisplayWidth = 300;

boolean _isCameraCtrl = false;
boolean _isDisplayModeList = false;
int _ctrlLampID;
int _timer;
float _saveAlpha = 0.0f;
String _modeName = "Free";

lampsModeMgr _lampsModeMgr = new lampsModeMgr();
lampStruct[] _lampStruct = new lampStruct[4];
PVector[] _lampStructPos = new PVector[4];
bpmPad _bpmPad = new bpmPad(1024, 500);
PGraphics _lampCanvas, _padCanvas;
MidiBus _midi;

//------------------------
void setup()
{
  size(1024, 900, P3D);
  _lampCanvas = createGraphics(1024, 400, P3D);
  _padCanvas = createGraphics(1024, 500);
  loadJSON();
  _ctrlLampID = 0;
  _timer = millis();

  //Midi
  //MidiBus.list();
  _midi = new MidiBus(this, "nanoKONTROL2", -1);
  initLampStruct();
}

//------------------------
void update()
{
  float delta = (millis() - _timer)/1000.0;
  _timer = millis();
  _bpmPad.update(delta);

  beatTrigger(_bpmPad.getTriggerIndex());

  //Draw on lampCanvas
  _lampCanvas.beginDraw();
  {
    _lampCanvas.background(0);
    if (_isCameraCtrl)
    {
      _lampCanvas.camera(mouseX, _lampCanvas.height/2, (_lampCanvas.height/2) / tan(PI/6), _lampCanvas.width/2, _lampCanvas.height/2, 0, 0, 1, 0);
    }

    for (int i = 0; i < 4; i++)
    {
      _lampStruct[i].draw(_lampCanvas, _lampStructPos[i], (i == _ctrlLampID));
    }
  }
  _lampCanvas.endDraw();

  //Draw on padCanvas
  _padCanvas.beginDraw();
  {
    _padCanvas.background(0);
    _bpmPad.display(_padCanvas);
  }
  _padCanvas.endDraw();

  //Save Alpha
  if (_saveAlpha >= 0.0f)
  {
    _saveAlpha *= 0.98;
    if (_saveAlpha < 20)
    {
      _saveAlpha = 0.0f;
    }
  }
}

//------------------------
void draw()
{
  update();
  background(0);

  image(_lampCanvas, 0, 0);
  image(_padCanvas, 0, _lampCanvas.height);

  displayMsg();

  if (_isDisplayModeList)
  {
    _lampsModeMgr.displayNameList(width - 300, 0);
  }
}

//------------------------
void initLampStruct()
{
  _lampStruct[0] = new lampStruct(200);
  _lampStructPos[0] = new PVector(_lampCanvas.width/4, _lampCanvas.height/2, 0);

  _lampStruct[1] = new lampStruct(200);
  _lampStructPos[1] = new PVector(_lampCanvas.width * 3/4, _lampCanvas.height/2, 0);

  _lampStruct[2] = new lampStruct(100);
  _lampStructPos[2] = new PVector(_lampCanvas.width/4, _lampCanvas.height/2, 0);

  _lampStruct[3] = new lampStruct(100);
  _lampStructPos[3] = new PVector(_lampCanvas.width * 3/4, _lampCanvas.height/2, 0);
}

//------------------------
void displayMsg()
{
  pushStyle();
  fill(255);
  textSize(16);

  //BPM
  text("BPM(+/-):" + _bpmPad.getBPM(), 0, 20);

  //Camera Ctrl
  text("Camera Ctrl(c):" + _isCameraCtrl, 0, 40);

  //Mode
  text("Mode(m) : " + _modeName, 0, 60);

  //How-to
  text("Play(p)", 0, 80);
  text("Stop(s)", 0, 100);

  //Save message
  fill(255, 255, 255, _saveAlpha);
  text("Save Success", 0, 120);

  popStyle();
}

//------------------------
void changeControlLamp()
{
  _bpmPad.setPadData(_lampStruct[_ctrlLampID].getLampState());
}

//------------------------
void changeMode(int id)
{
  if (id == -1)
  {
    _modeName = "Free";
    _bpmPad.clear();
    for (int i = 0; i < 4; i++)
    {
      _lampStruct[i].clear();
    }
  } else if (id >= 0 && id < _lampsModeMgr.getModeNum())
  {
    _modeName = _lampsModeMgr.getModeName(id);
    lampsState[] state = _lampsModeMgr.getLampsState(id);

    for (int i = 0; i < 4; i++)
    {
      _lampStruct[i].setLampState(state[i]);
    }    
    _bpmPad.setPadData(state[_ctrlLampID]);
  }
}

//------------------------
void clearAll()
{
  _modeName = "Free";
  _bpmPad.clear();
  for (int i = 0; i < 4; i++)
  {
    _lampStruct[i].clear();
  }
}

//------------------------
void beatTrigger(int index)
{
  if (index == -1)
  {
    return;
  }
  for (int i = 0; i < 4; i++)
  {
    _lampStruct[i].updateState(index);
  }
}

//------------------------
String[] getModeList()
{
  String path = sketchPath("\\data\\mode");

  File file = new File(path);

  if (file.isDirectory())
  {

    return file.list();
  } else
  {
    return new String[0];
  }
}

//------------------------
void loadJSON()
{
  String[] fileNameList = getModeList();

  for (String file : fileNameList)
  {
    String modeName = file.substring(0, file.lastIndexOf('.'));
    _lampsModeMgr.addByJson(modeName, loadJSONObject("data/mode/" + file));
  }
}

//------------------------
void outputJSON()
{
  JSONObject json = new JSONObject();
  for (int i = 0; i < 4; i++)
  {
    lampsState data = _lampStruct[i].getLampState();
    JSONArray lampArray = new JSONArray();
    for (int lampIdx = 0; lampIdx < cLampNum; lampIdx++)
    {
      JSONArray array = new JSONArray();
      for (int beatIdx = 0; beatIdx < cBeatNum; beatIdx++)
      {
        array.setBoolean(beatIdx, data.get(lampIdx, beatIdx));
      }
      lampArray.setJSONArray(lampIdx, array);
    }
    json.setJSONArray(Integer.toString(i), lampArray);
  }

  String fileName = new String();
  fileName += "mode_" + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(minute()) + String.valueOf(second()) + ".json";
  saveJSONObject(json, "data/output/" + fileName);
  _saveAlpha = 255.0;
}

//------------------------
void controllerChange(int channel, int number, int value) 
{
  boolean isOn = (value == 127);
  midiType type = midiMapper.getType(number);
  switch(type)
  {
  case eModeBtn:
    {
      if (isOn)
      {
        changeMode(midiMapper.getModeID(number));
      }
      break;
    }
  case eSpeedKnob:
    {
      _bpmPad.setBPM(round(map(value, 0, 127, 50, 300)));
      break;
    }
  case ePlayBtn:
    {
      if (isOn)
      {
        _bpmPad.play();
      }
      break;
    }
  case eStopBtn:
    {
      if (isOn)
      {
        _bpmPad.stop();
      }

      break;
    }
  case eClearBtn:
    {
      if (isOn)
      {
        clearAll();
      }
      break;
    }
  case eNextLamps:
    {
      if (isOn)
      {
        _ctrlLampID = (_ctrlLampID + 1) % 4;
        changeControlLamp();
      }
      break;
    }
  case ePrevLamps:
    {
      if (isOn)
      {
        _ctrlLampID--;
        if (_ctrlLampID < 0)
        {
          _ctrlLampID += 4;
        }
        changeControlLamp();
      }
      break;
    }
  default:
    {
      break;
    }
  }
}

//------------------------
void keyPressed()
{
  switch(key)
  {
  case '0':
  case '1':
  case '2':
  case '3':
  case '4':
  case '5':
  case '6':
  case '7':
  case '8':
  case '9':
    {
      changeMode(key - '1');
      break;
    }
  case 'q':
    {
      _ctrlLampID--;
      if (_ctrlLampID < 0)
      {
        _ctrlLampID += 4;
      }
      changeControlLamp();
      break;
    }
  case 'w':
    {
      _ctrlLampID = (_ctrlLampID + 1) % 4;
      changeControlLamp();
      break;
    }
  case '-':
    {
      _bpmPad.sub();
      break;
    }
  case '+':
    {
      _bpmPad.add();
      break;
    }
  case 'c':
    {
      _isCameraCtrl ^= true;
      break;
    }
  case 'm':
    {
      _isDisplayModeList ^= true;
      break;
    }
  case 'p':
    {
      _bpmPad.play();
      break;
    }
  case 's':
    {
      _bpmPad.stop();
      break;
    }
  case 'o':
    {
      outputJSON();
      break;
    }
  }
}

//------------------------
void mouseReleased()
{
  if (mouseY >= _lampCanvas.height)
  {
    int[] lampIdx = {0};
    int[] beatIdx = {0};

    boolean isOn = _bpmPad.mouseRelease(mouseX, mouseY - _lampCanvas.height, lampIdx, beatIdx);
    _lampStruct[_ctrlLampID].setLampState(lampIdx[0], beatIdx[0], isOn);
  }
}