mmCreateView("RaycastVolumeExample", "View3DGL", "::RaycastVolumeExample::View3DGL1")

mmCreateModule("BoundingBoxRenderer", "::RaycastVolumeExample::BoundingBoxRenderer1")

mmCreateModule("RaycastVolumeRenderer", "::RaycastVolumeExample::RaycastVolumeRenderer1")
mmSetParamValue("::RaycastVolumeExample::RaycastVolumeRenderer1::ray step ratio", [=[0.1]=])

mmCreateModule("TransferFunctionGL", "::RaycastVolumeExample::TransferFunction1")
mmSetParamValue("::RaycastVolumeExample::TransferFunction1::TransferFunction", [=[{ "IgnoreProjectRange": true, 
"Interpolation":"LINEAR",
"Nodes":[
[0.0,0.0,0.0,0.0,0.0,0.05000000074505806],
[0.14127187430858612,0.5980616211891174,0.1649588644504547,0.07333332300186157,0.18036529421806335,0.05000000074505806],
[0.45831984281539917,0.21742291748523712,0.1543489694595337,0.3399999737739563,0.3076712191104889,0.05000000074505806],
[0.6666666269302368,0.6666666269302368,0.6666666269302368,0.40666669607162476,0.5452054738998413,0.05000000074505806],
[1.0,1.0,1.0,1.0,1.0,0.05000000074505806]],
"TextureSize":256,
"ValueRange":[0.0,1.0]
}]=])

mmCreateModule("VolumetricDataSource", "::RaycastVolumeExample::VolumetricDataSource1")
mmSetParamValue("::RaycastVolumeExample::VolumetricDataSource1::FileName", [=[../examples/sampledata/bonsai.dat]=])

mmCreateModule("ScreenShooter", "::RaycastVolumeExample::ScreenShooter1")
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::view", [=[::RaycastVolumeExample::View3DGL1]=])
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::imgWidth", [=[1920]=])
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::imgHeight", [=[1080]=])
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::tileWidth", [=[1920]=])
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::tileHeight", [=[1080]=])
mmSetParamValue("::RaycastVolumeExample::ScreenShooter1::filename", [=[RaycastVolumeRenderer.png]=])

mmCreateCall("CallGetTransferFunctionGL", "::RaycastVolumeExample::RaycastVolumeRenderer1::getTransferFunction", "::RaycastVolumeExample::TransferFunction1::gettransferfunction")
mmCreateCall("VolumetricDataCall", "::RaycastVolumeExample::RaycastVolumeRenderer1::getData", "::RaycastVolumeExample::VolumetricDataSource1::GetData")
mmCreateCall("CallRender3DGL", "::RaycastVolumeExample::View3DGL1::rendering", "::RaycastVolumeExample::BoundingBoxRenderer1::rendering")
mmCreateCall("CallRender3DGL", "::RaycastVolumeExample::BoundingBoxRenderer1::chainRendering", "::RaycastVolumeExample::RaycastVolumeRenderer1::rendering")
