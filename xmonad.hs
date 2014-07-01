import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import System.IO
import XMonad.Layout.IndependentScreens

myWorkspaces = ["1:main","2:xp","3:py","4:mail"] ++ map show [5..9]

myManageHooks = manageDocks <+> manageHook defaultConfig <+> composeAll [ isFullscreen --> doFullFloat ]

myLayoutHooks = smartBorders $ avoidStruts ( tiled ||| Mirror tiled ||| noBorders (fullscreenFull Full))
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
		workspaces = myWorkspaces,
		manageHook = myManageHooks,
		layoutHook = myLayoutHooks,
		borderWidth = 2,
		logHook = dynamicLogWithPP xmobarPP
				{ ppOutput = hPutStrLn xmproc
				, ppTitle = xmobarColor "green" "" . shorten 50
				},
		modMask = mod4Mask
		} `additionalKeys`
		[ ((mod4Mask .|. shiftMask, xK_l), spawn "slock")
		, ((0                     , 0x1008FF11), spawn "amixer -c 1 set Master 2-")
		, ((0                     , 0x1008FF13), spawn "amixer -c 1 set Master 2+")
		, ((0                     , 0x1008FF12), spawn "amixer -c 1 set Master toggle")
		, ((0                     , xK_Print), spawn "scrot $HOME/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1")
		]
