// Auto-generated
let project = new Project('armoryGame');

project.addSources('Sources');
project.addLibrary("E:/SteamLibrary/steamapps/common/Blender/ArmorySDK/armory");
project.addLibrary("E:/SteamLibrary/steamapps/common/Blender/ArmorySDK/iron");
project.addParameter('arm.node.CharacterNode');
project.addParameter("--macro keep('arm.node.CharacterNode')");
project.addShaders("build_armoryGame/compiled/Shaders/*.glsl", { noembed: false});
project.addShaders("build_armoryGame/compiled/Hlsl/*.glsl", { noprocessing: true, noembed: false });
project.addAssets("build_armoryGame/compiled/Assets/**", { notinlist: true });
project.addAssets("build_armoryGame/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("E:/SteamLibrary/steamapps/common/Blender/ArmorySDK/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("E:/SteamLibrary/steamapps/common/Blender/ArmorySDK/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("E:/SteamLibrary/steamapps/common/Blender/ArmorySDK/armory/Assets/smaa_search.png", { notinlist: true });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('arm_ltc');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('arm_audio');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_skin');
project.addDefine('arm_particles');


resolve(project);