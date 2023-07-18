为了使 openfst 通过直接链接 fst.{a,so} 的方式使用 const/lookahead/compact 等扩展，需要

1. 设置宏 FST_NO_DYNAMIC_LINKING，其在 windows 版本的 FST 中已直接配置，详见 https://github.com/kkm000/openfst/blob/win/1.6.5.1/src/include/fst/config.h。
2. 标准的 fst 编译中 libfst.so 和 libextXXX.so 是单独模块化编译，为了方便可直接把用到的 fst extension 编译进 fst.{a,so}，详见 patch/openfst/CMakeLists.txt。
