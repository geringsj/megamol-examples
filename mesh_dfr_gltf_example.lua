mmCreateView("GraphEntry_1","View3DGL","::View3DGL1")

mmCreateModule("AntiAliasing","::Lighting&Post::AntiAliasing_1")
mmCreateModule("SSAO","::Lighting&Post::SSAO_1")
mmCreateModule("DistantLight","::Lighting&Post::DistantLight1")
mmCreateModule("TextureCombine","::Lighting&Post::TextureCombine1")
mmCreateModule("LocalLighting","::Lighting&Post::LocalLighting1")
mmCreateModule("SimpleRenderTarget","::SimpleRenderTarget1")
mmCreateModule("GlTFFileLoader","::GlTFFileLoader1")
mmCreateModule("BoundingBoxRenderer","::BoundingBoxRenderer1")
mmCreateModule("DrawToScreen","::DrawToScreen1")
mmCreateModule("DeferredGltfRenderer","::DeferredGltfRenderer_1")

mmCreateCall("CallRender3DGL","::View3DGL1::rendering","::BoundingBoxRenderer1::rendering")
mmCreateCall("CallTexture2D","::Lighting&Post::AntiAliasing_1::InputTexture","::Lighting&Post::TextureCombine1::OutputTexture")
mmCreateCall("CallTexture2D","::Lighting&Post::SSAO_1::NormalTexture","::SimpleRenderTarget1::Normals")
mmCreateCall("CallTexture2D","::Lighting&Post::SSAO_1::DepthTexture","::SimpleRenderTarget1::Depth")
mmCreateCall("CallCamera","::Lighting&Post::SSAO_1::Camera","::SimpleRenderTarget1::Camera")
mmCreateCall("CallTexture2D","::Lighting&Post::TextureCombine1::InputTexture0","::Lighting&Post::LocalLighting1::OutputTexture")
mmCreateCall("CallTexture2D","::Lighting&Post::TextureCombine1::InputTexture1","::Lighting&Post::SSAO_1::OutputTexture")
mmCreateCall("CallTexture2D","::Lighting&Post::LocalLighting1::AlbedoTexture","::SimpleRenderTarget1::Color")
mmCreateCall("CallTexture2D","::Lighting&Post::LocalLighting1::NormalTexture","::SimpleRenderTarget1::Normals")
mmCreateCall("CallTexture2D","::Lighting&Post::LocalLighting1::DepthTexture","::SimpleRenderTarget1::Depth")
mmCreateCall("CallLight","::Lighting&Post::LocalLighting1::lights","::Lighting&Post::DistantLight1::deployLightSlot")
mmCreateCall("CallCamera","::Lighting&Post::LocalLighting1::Camera","::SimpleRenderTarget1::Camera")
mmCreateCall("CallRender3DGL","::SimpleRenderTarget1::chainRendering","::DeferredGltfRenderer_1::rendering")
mmCreateCall("CallRender3DGL","::BoundingBoxRenderer1::chainRendering","::DrawToScreen1::rendering")
mmCreateCall("CallRender3DGL","::DrawToScreen1::chainRendering","::SimpleRenderTarget1::rendering")
mmCreateCall("CallTexture2D","::DrawToScreen1::InputTexture","::Lighting&Post::AntiAliasing_1::OutputTexture")
mmCreateCall("CallTexture2D","::DrawToScreen1::DepthTexture","::SimpleRenderTarget1::Depth")
mmCreateCall("CallMesh","::DeferredGltfRenderer_1::meshes","::GlTFFileLoader1::meshes")
mmCreateCall("CallGlTFData","::DeferredGltfRenderer_1::gltfModels","::GlTFFileLoader1::gltfModels")

mmSetParamValue("::View3DGL1::camstore::settings",[=[]=])
mmSetParamValue("::View3DGL1::camstore::overrideSettings",[=[false]=])
mmSetParamValue("::View3DGL1::camstore::autoSaveSettings",[=[false]=])
mmSetParamValue("::View3DGL1::camstore::autoLoadSettings",[=[true]=])
mmSetParamValue("::View3DGL1::resetViewOnBBoxChange",[=[false]=])
mmSetParamValue("::View3DGL1::showLookAt",[=[false]=])
mmSetParamValue("::View3DGL1::view::showViewCube",[=[false]=])
mmSetParamValue("::View3DGL1::anim::play",[=[false]=])
mmSetParamValue("::View3DGL1::anim::speed",[=[4.000000]=])
mmSetParamValue("::View3DGL1::anim::time",[=[0.000000]=])
mmSetParamValue("::View3DGL1::backCol",[=[#000020]=])
mmSetParamValue("::View3DGL1::viewKey::MoveStep",[=[0.500000]=])
mmSetParamValue("::View3DGL1::viewKey::RunFactor",[=[2.000000]=])
mmSetParamValue("::View3DGL1::viewKey::AngleStep",[=[90.000000]=])
mmSetParamValue("::View3DGL1::viewKey::FixToWorldUp",[=[true]=])
mmSetParamValue("::View3DGL1::viewKey::MouseSensitivity",[=[3.000000]=])
mmSetParamValue("::View3DGL1::viewKey::RotPoint",[=[Look-At]=])
mmSetParamValue("::View3DGL1::view::cubeOrientation",[=[0;0;0;1]=])
mmSetParamValue("::View3DGL1::view::defaultView",[=[FACE - Front]=])
mmSetParamValue("::View3DGL1::view::defaultOrientation",[=[Top]=])
mmSetParamValue("::View3DGL1::cam::position",[=[0;0;0.56443423]=])
mmSetParamValue("::View3DGL1::cam::orientation",[=[0;-0;-0;1]=])
mmSetParamValue("::View3DGL1::cam::projectiontype",[=[Perspective]=])
mmSetParamValue("::View3DGL1::cam::nearplane",[=[0.000156]=])
mmSetParamValue("::View3DGL1::cam::farplane",[=[1.564434]=])
mmSetParamValue("::View3DGL1::cam::halfaperturedegrees",[=[28.647890]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::Mode",[=[SMAA]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::SMAA Mode",[=[SMAA 1x]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::QualityLevel",[=[High]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::Threshold",[=[0.100000]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::MaxSearchSteps",[=[16]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::MaxDiagSearchSteps",[=[8]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::DisableDiagDetection",[=[false]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::DisableCornerDetection",[=[false]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::CornerRounding",[=[25]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::EdgeDetection",[=[Luma]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::Show",[=[true]=])
mmSetParamValue("::Lighting&Post::AntiAliasing_1::Texture",[=[Output]=])
mmSetParamValue("::Lighting&Post::SSAO_1::SSAO",[=[ASSAO]=])
mmSetParamValue("::Lighting&Post::SSAO_1::SSAO Radius",[=[0.500000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::SSAO Samples",[=[16]=])
mmSetParamValue("::Lighting&Post::SSAO_1::Radius",[=[0.050000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::ShadowMultiplier",[=[1.000000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::ShadowPower",[=[1.500000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::ShadowClamp",[=[0.980000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::HorizonAngleThreshold",[=[0.060000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::FadeOutFrom",[=[50.000000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::FadeOutTo",[=[300.000000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::QualityLevel",[=[High]=])
mmSetParamValue("::Lighting&Post::SSAO_1::AdaptiveQualityLimit",[=[0.450000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::BlurPassCount",[=[2]=])
mmSetParamValue("::Lighting&Post::SSAO_1::Sharpness",[=[0.980000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::TemporalSupersamplingAngleOffset",[=[0.000000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::TemporalSupersamplingRadiusOffset",[=[1.000000]=])
mmSetParamValue("::Lighting&Post::SSAO_1::DetailShadowStrength",[=[0.500000]=])
mmSetParamValue("::Lighting&Post::DistantLight1::Intensity",[=[1.000000]=])
mmSetParamValue("::Lighting&Post::DistantLight1::Color",[=[#cccccc]=])
mmSetParamValue("::Lighting&Post::DistantLight1::Direction",[=[-0.246649146;-0.477438658;-0.765648007]=])
mmSetParamValue("::Lighting&Post::DistantLight1::AngularDiameter",[=[0.000000]=])
mmSetParamValue("::Lighting&Post::DistantLight1::EyeDirection",[=[true]=])
mmSetParamValue("::Lighting&Post::TextureCombine1::Mode",[=[Multiply]=])
mmSetParamValue("::Lighting&Post::TextureCombine1::Weight0",[=[0.500000]=])
mmSetParamValue("::Lighting&Post::TextureCombine1::Weight1",[=[0.500000]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::IlluminationMode",[=[Lambert]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::AmbientColor",[=[#ffffff]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::DiffuseColor",[=[#ffffff]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::SpecularColor",[=[#ffffff]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::AmbientFactor",[=[0.200000]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::DiffuseFactor",[=[0.700000]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::SpecularFactor",[=[0.100000]=])
mmSetParamValue("::Lighting&Post::LocalLighting1::ExponentialFactor",[=[120.000000]=])
mmSetParamValue("::GlTFFileLoader1::glTF filename",[=[../examples/sampledata/mesh/WaterBottle/glTF/WaterBottle.gltf]=])
mmSetParamValue("::BoundingBoxRenderer1::enableBoundingBox",[=[true]=])
mmSetParamValue("::BoundingBoxRenderer1::boundingBoxColor",[=[#ffffff]=])
mmSetParamValue("::BoundingBoxRenderer1::smoothLines",[=[true]=])
mmSetParamValue("::BoundingBoxRenderer1::enableViewCube",[=[false]=])
mmSetParamValue("::BoundingBoxRenderer1::viewCubePosition",[=[top right]=])
mmSetParamValue("::BoundingBoxRenderer1::viewCubeSize",[=[100]=])

