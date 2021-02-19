﻿-- Adapt the following variables to your needs:

project_file = "../examples/testspheres.lua"
keyframe_file = "../examples/cinematic/testspheres_keyframes.kf"

--- Do not change anything below ----------------------------------------------

mmCreateView("cinematic_editor", "GUIView", "::cinematic::GUIView1")
mmCreateModule("SplitViewGL", "::cinematic::SplitViewGL1")
mmSetParamValue("::cinematic::SplitViewGL1::split.orientation", [=[1]=])
mmSetParamValue("::cinematic::SplitViewGL1::split.pos", [=[0.65]=])
mmSetParamValue("::cinematic::SplitViewGL1::split.colour", [=[white]=])

mmCreateModule("SplitViewGL", "::cinematic::SplitViewGL2")
mmSetParamValue("::cinematic::SplitViewGL2::split.pos", [=[0.55]=])
mmSetParamValue("::cinematic::SplitViewGL2::split.colour", [=[white]=])

mmCreateModule("KeyframeKeeper", "::cinematic::KeyframeKeeper1")
mmSetParamValue("::cinematic::KeyframeKeeper1::storage::filename", keyframe_file)

mmCreateModule("View2DGL", "::cinematic::View2DGL1")
mmSetParamValue("::cinematic::View2DGL1::backCol", [=[black]=])
mmSetParamValue("::cinematic::View2DGL1::resetViewOnBBoxChange", [=[True]=])
mmSetParamValue("::cinematic::View2DGL1::showBBox", [=[false]=])

mmCreateModule("View3DGL", "::cinematic::View3DGL1")
mmSetParamValue("::cinematic::View3DGL1::backCol", [=[black]=])

mmCreateModule("TimeLineRenderer", "::cinematic::TimeLineRenderer1")

mmCreateModule("TrackingshotRenderer", "::cinematic::TrackingshotRenderer1")

mmCreateModule("CinematicView", "::cinematic::CinematicView1")
mmSetParamValue("::cinematic::CinematicView1::backCol", [=[Gray]=])
mmSetParamValue("::cinematic::CinematicView1::cinematic::fps", [=[24]=])

mmCreateModule("ReplacementRenderer", "::cinematic::ReplacementRenderer1")
mmSetParamValue("::cinematic::ReplacementRenderer1::hotkeyAssignment", [=[Alt + 1]=])
mmSetParamValue("::cinematic::ReplacementRenderer1::replacement", [=[true]=])

mmCreateModule("ReplacementRenderer", "::cinematic::ReplacementRenderer2")
mmSetParamValue("::cinematic::ReplacementRenderer2::hotkeyAssignment", [=[Alt + 2]=])
mmSetParamValue("::cinematic::ReplacementRenderer2::replacement", [=[false]=])

mmCreateCall("CallRenderViewGL", "::cinematic::GUIView1::renderview", "::cinematic::SplitViewGL1::render")
mmCreateCall("CallRenderViewGL", "::cinematic::SplitViewGL1::render1", "::cinematic::SplitViewGL2::render")
mmCreateCall("CallRenderViewGL", "::cinematic::SplitViewGL1::render2", "::cinematic::View2DGL1::render")
mmCreateCall("CallRenderViewGL", "::cinematic::SplitViewGL2::render1", "::cinematic::View3DGL1::render")
mmCreateCall("CallKeyframeKeeper", "::cinematic::TimeLineRenderer1::keyframeData", "::cinematic::KeyframeKeeper1::keyframeData")
mmCreateCall("CallRender3DGL", "::cinematic::View3DGL1::rendering", "::cinematic::TrackingshotRenderer1::rendering")
mmCreateCall("CallKeyframeKeeper", "::cinematic::TrackingshotRenderer1::keyframeData", "::cinematic::KeyframeKeeper1::keyframeData")
mmCreateCall("CallRender3DGL", "::cinematic::TrackingshotRenderer1::chainRendering", "::cinematic::ReplacementRenderer1::rendering")
mmCreateCall("CallRender2D", "::cinematic::View2DGL1::rendering", "::cinematic::TimeLineRenderer1::rendering")
mmCreateCall("CallRenderViewGL", "::cinematic::SplitViewGL2::render2", "::cinematic::CinematicView1::render")
mmCreateCall("CallKeyframeKeeper", "::cinematic::CinematicView1::keyframeData", "::cinematic::KeyframeKeeper1::keyframeData")
mmCreateCall("CallRender3DGL", "::cinematic::CinematicView1::rendering", "::cinematic::ReplacementRenderer2::rendering")

function trafo(str)

  -- Break if SplitViewGL or CinematicView occure anywhere in the project
  local startpos, endpos, word = str:find("SplitViewGL")
  if not (startpos == nil) then
    print( "lua ERROR: Cinematic Editor can not be used with projects containing \"SplitViewGL\"."  )
    return ""
  end
  startpos, endpos, word = str:find("CinematicView")
  if not (startpos == nil) then
    print( "lua ERROR: Cinematic Editor can not be used with projects containing \"CinematicView\"."  )
    return ""
  end  

  local viewclass, viewmoduleinst
  startpos, endpos, word = str:find("mmCreateView%(.-,%s*[\"\']([^\"\']+)[\"\']%s*,.-%)")
  if word == "GUIView" then
    print( "lua INFO: Found \"GUIView\" as head view." )
    startpos, endpos, word = str:find("mmCreateModule%(.-View.-%)")
    local substring = str:sub(startpos, endpos)
    viewclass, viewmoduleinst = substring:match(
      'mmCreateModule%(%s*[\"\']([^\"\']+)[\"\']%s*,%s*[\"\']([^\"\']+)[\"\']%s*%)')
  else
     viewclass, viewmoduleinst = str:match(
      'mmCreateView%(.-,%s*[\"\']([^\"\']+)[\"\']%s*,%s*[\"\']([^\"\']+)[\"\']%s*%)')
  end
  print("lua INFO: View Class = " .. viewclass)
  print("lua INFO: View Module Instance = " .. viewmoduleinst)

  local newcontent  = str:gsub("mmCreateView%(.-%)", "")
  newcontent = newcontent:gsub("mmCreateModule%(.-\"View.-%)", "")
  newcontent = newcontent:gsub("mmCreateCall%(\"CallRenderViewGL.-%)", "")
  newcontent = newcontent:gsub('mmCreateCall%([\"\']CallRender3DGL[\'\"],%s*[\'\"]' .. '.-' .. viewmoduleinst .. '::rendering[\'\"],([^,]+)%)', 
  'mmCreateCall("CallRender3DGL", "::cinematic::ReplacementRenderer1::chainRendering",%1)' .. "\n" .. 
  'mmCreateCall("CallRender3DGL", "::cinematic::ReplacementRenderer2::chainRendering",%1)')
  
  -- Assign all parameter values of main view in given project file to cinematic view:
  local newestcontent = newcontent:gsub('mmSetParamValue%([\"\']' .. viewmoduleinst .. '(.*)%)', 'mmSetParamValue("::cinematic::CinematicView1%1)')
  while newcontent ~= newestcontent do
    newcontent = newestcontent
    newestcontent = newcontent:gsub('mmSetParamValue%([\"\']' .. viewmoduleinst .. '(.*)%)', 'mmSetParamValue("::cinematic::CinematicView1%1)')
  end

  return newestcontent
end

local content = mmReadTextFile(project_file, trafo)
print("lua INFO: Transformed Given Project File =\n" .. content .. "\n\n ")
code = load(content)
code()

-- <GUI_STATE_JSON>{"ConfiguratorState":{"module_list_sidebar_width":250.0,"show_module_list_sidebar":false},"GUIState":{"menu_visible":false,"style":2},"GraphStates":{"Project":{"Interfaces":{"cinematic":{"interface_slot_0":["::cinematic::ReplacementRenderer2::chainRendering"],"interface_slot_1":["::cinematic::ReplacementRenderer1::chainRendering"]}},"Modules":{"::cinematic::CinematicView1":{"graph_position":[804.0,216.0]},"::cinematic::GUIView1":{"graph_position":[96.0,112.0]},"::cinematic::KeyframeKeeper1":{"graph_position":[1326.7998046875,352.71112060546875]},"::cinematic::ReplacementRenderer1":{"graph_position":[1362.0,112.0]},"::cinematic::ReplacementRenderer2":{"graph_position":[1363.4222412109375,210.66668701171875]},"::cinematic::SplitViewGL1":{"graph_position":[332.0,112.0]},"::cinematic::SplitViewGL2":{"graph_position":[568.0,112.0]},"::cinematic::TimeLineRenderer1":{"graph_position":[804.0,344.0]},"::cinematic::TrackingshotRenderer1":{"graph_position":[1074.0,112.0]},"::cinematic::View2DGL1":{"graph_position":[568.0,240.0]},"::cinematic::View3DGL1":{"graph_position":[804.0,112.0]}},"canvas_scrolling":[68.26663208007813,256.0888671875],"canvas_zooming":0.5113636255264282,"param_extended_mode":false,"parameter_sidebar_width":300.0,"params_readonly":false,"params_visible":true,"project_name":"cinematic","show_call_names":true,"show_grid":false,"show_module_names":true,"show_parameter_sidebar":false,"show_slot_names":false}},"ParameterStates":{"::cinematic::CinematicView1::ParameterGroup::anim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::SpeedDown":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::SpeedUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::play":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::speed":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::time":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::anim::togglePlay":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::backCol":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::centeroffset":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::convergenceplane":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::halfaperturedegrees":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::halfdisparity":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::orientation":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::ovr::lookat":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::ovr::override":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::ovr::up":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::position":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cam::projectiontype":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::autoLoadSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::autoSaveSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::overrideSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::restorecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::settings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::camstore::storecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::addSBSideToName":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::cinematicHeight":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::cinematicWidth":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::delayFirstFrame":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::firstFrame":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::fps":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::frameFolder":{"gui_presentation_mode":16,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::lastFrame":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::playPreview":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::renderAnim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::skyboxCubeMode":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::skyboxSide":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::stereo_eye":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::cinematic::stereo_projection":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::enableMouseSelection":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::hookOnChange":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::resetView":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::resetViewOnBBoxChange":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::showLookAt":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::softCursor":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::AngleStep":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::FixToWorldUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::MouseSensitivity":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::MoveStep":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::RotPoint":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewKey::RunFactor":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::CinematicView1::viewcube::show":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::applyKeyframe":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::deleteKeyframe":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::animTime":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::apertureAngle":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::lookAtVector":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::positionVector":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::resetLookAt":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::simTime":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::editSelected::upVector":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::interpolTangent":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::linearizeSimTime":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::maxAnimTime":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::redoChanges":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::snapAnimFrames":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::snapSimFrames":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::storage::filename":{"gui_presentation_mode":16,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::storage::load":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::storage::save":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::KeyframeKeeper1::undoChanges":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer1::alpha":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer1::hotkeyAssignment":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer1::replacement":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer1::toggleReplacement":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer2::alpha":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer2::hotkeyAssignment":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer2::replacement":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::ReplacementRenderer2::toggleReplacement":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::ParameterGroup::anim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::SpeedDown":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::SpeedUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::play":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::speed":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::time":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::anim::togglePlay":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::inputToBoth":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::split.colour":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::split.orientation":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::split.pos":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::split.width":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL1::timeLord":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::ParameterGroup::anim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::SpeedDown":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::SpeedUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::play":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::speed":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::time":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::anim::togglePlay":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::inputToBoth":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::split.colour":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::split.orientation":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::split.pos":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::split.width":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::SplitViewGL2::timeLord":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TimeLineRenderer1::gotoLeftFrame":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TimeLineRenderer1::gotoRightFrame":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TimeLineRenderer1::resetAxes":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TrackingshotRenderer1::helpText":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TrackingshotRenderer1::manipulators::showOutsideBBox":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TrackingshotRenderer1::manipulators::toggleVisibleGroup":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TrackingshotRenderer1::manipulators::visibleGroup":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::TrackingshotRenderer1::splineSubdivision":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::ParameterGroup::anim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::SpeedDown":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::SpeedUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::play":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::speed":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::time":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::anim::togglePlay":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::backCol":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::bboxCol":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::camstore::restorecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::camstore::settings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::camstore::storecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::resetView":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::resetViewOnBBoxChange":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::showBBox":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View2DGL1::softCursor":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::ParameterGroup::anim":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::SpeedDown":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::SpeedUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::play":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::speed":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::time":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::anim::togglePlay":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::backCol":{"gui_presentation_mode":8,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::centeroffset":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::convergenceplane":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::halfaperturedegrees":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::halfdisparity":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::orientation":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::ovr::lookat":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::ovr::override":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::ovr::up":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::position":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::cam::projectiontype":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::autoLoadSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::autoSaveSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::overrideSettings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::restorecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::settings":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::camstore::storecam":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::enableMouseSelection":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::hookOnChange":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::resetView":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::resetViewOnBBoxChange":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::showLookAt":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::softCursor":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::AngleStep":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::FixToWorldUp":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::MouseSensitivity":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::MoveStep":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::RotPoint":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewKey::RunFactor":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true},"::cinematic::View3DGL1::viewcube::show":{"gui_presentation_mode":2,"gui_read-only":false,"gui_visibility":true}},"WindowConfigurations":{"All Parameters":{"font_name":"","log_force_open":true,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":1,"win_collapsed":false,"win_flags":8,"win_hotkey":[300,0],"win_position":[0.0,18.0],"win_reset_position":[0.0,0.0],"win_reset_size":[400.0,600.0],"win_show":false,"win_size":[400.0,600.0],"win_soft_reset":false},"Configurator":{"font_name":"","log_force_open":true,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":6,"win_collapsed":false,"win_flags":1032,"win_hotkey":[296,0],"win_position":[0.0,18.0],"win_reset_position":[0.0,18.0],"win_reset_size":[800.0,600.0],"win_show":false,"win_size":[1280.0,702.0],"win_soft_reset":false},"Font Settings":{"font_name":"","log_force_open":true,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":4,"win_collapsed":false,"win_flags":64,"win_hotkey":[298,0],"win_position":[0.0,0.0],"win_reset_position":[0.0,0.0],"win_reset_size":[400.0,600.0],"win_show":false,"win_size":[400.0,600.0],"win_soft_reset":true},"Log Console":{"font_name":"","log_force_open":false,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":7,"win_collapsed":false,"win_flags":3072,"win_hotkey":[295,0],"win_position":[0.0,500.0],"win_reset_position":[0.0,0.0],"win_reset_size":[850.0,250.0],"win_show":false,"win_size":[1280.0,220.0],"win_soft_reset":false},"Performance Metrics":{"font_name":"","log_force_open":true,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":3,"win_collapsed":false,"win_flags":65,"win_hotkey":[299,0],"win_position":[0.0,0.0],"win_reset_position":[0.0,0.0],"win_reset_size":[400.0,600.0],"win_show":false,"win_size":[400.0,600.0],"win_soft_reset":true},"Transfer Function Editor":{"font_name":"","log_force_open":true,"log_level":4294967295,"ms_max_history_count":20,"ms_mode":0,"ms_refresh_rate":2.0,"ms_show_options":false,"param_extended_mode":false,"param_module_filter":0,"param_modules_list":[],"param_show_hotkeys":false,"tfe_active_param":"","tfe_view_minimized":false,"tfe_view_vertical":false,"win_callback":5,"win_collapsed":false,"win_flags":64,"win_hotkey":[297,0],"win_position":[0.0,0.0],"win_reset_position":[0.0,0.0],"win_reset_size":[400.0,600.0],"win_show":false,"win_size":[400.0,600.0],"win_soft_reset":true}}}</GUI_STATE_JSON>