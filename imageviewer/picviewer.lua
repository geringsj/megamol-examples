mmCreateView("pciviewer", "View3DGL", "::picviewer::view")
mmSetParamValue("::picviewer::view::resetViewOnBBoxChange",[=[true]=])
mmCreateModule("ImageRenderer", "::picviewer::ren")
mmSetParamValue("::picviewer::ren::pasteFiles", "../examples/imageviewer/Epic_Win_title_card.png")
mmCreateModule("BoundingBoxRenderer", "::picviewer::bboxRenderer")
mmCreateModule("ScreenShooter", "::picviewer::ScreenShooter1")
mmSetParamValue("::picviewer::ScreenShooter1::view", "::picviewer::view")
mmSetParamValue("::picviewer::ScreenShooter1::imgWidth", "1920")
mmSetParamValue("::picviewer::ScreenShooter1::imgHeight", "1080")
mmSetParamValue("::picviewer::ScreenShooter1::tileWidth", "1920")
mmSetParamValue("::picviewer::ScreenShooter1::tileHeight", "1080")
mmSetParamValue("::picviewer::ScreenShooter1::filename", "../examples/imageviewer/picviewer.png")
mmCreateCall("CallRender3DGL", "::picviewer::view::rendering", "::picviewer::bboxRenderer::rendering")
mmCreateCall("CallRender3DGL", "::picviewer::bboxRenderer::chainRendering", "::picviewer::ren::rendering")
