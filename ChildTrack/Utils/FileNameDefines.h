//
//  FileNameDefines.h
//  ChildTrack
//
//  Created by zzy on 11/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#ifndef FileNameDefines_h
#define FileNameDefines_h

#ifdef DEBUG

//追踪给他人查询历史缓存文件名
#define SearchHistoryFileName @"SearchHistoryFileDebug"

#else

//追踪给他人查询历史缓存文件名
#define SearchHistoryFileName @"SearchHistoryFile"

#endif

#endif /* FileNameDefines_h */
