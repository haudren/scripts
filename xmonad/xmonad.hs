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
import XMonad.Layout.WindowNavigation
import XMonad.Hooks.EwmhDesktops

myWorkspaces = ["1:main","2:xp","3:py","4:mail"] ++ map show [5..9]

myManageHooks = manageDocks <+> manageHook defaultConfig <+> composeAll [ isFullscreen --> doFullFloat  									,className =? "xcalendar" --> doFloat]

myLayoutHooks = windowNavigation $ smartBorders $ avoidStruts ( tiled ||| Mirror tiled ||| noBorders (fullscreenFull Full))
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh defaultConfig {
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
		[ ((mod4Mask .|. shiftMask, xK_Escape), spawn "slock")
		, ((0                     , 0x1008FF11), spawn "change_volume 2-")
		, ((0                     , 0x1008FF13), spawn "change_volume 2+")
		, ((0                     , 0x1008FF12), spawn "change_volume toggle")
		, ((0                     , 0x1008FF14), spawn "mediacontrol pause")
		, ((0                     , 0x1008FF16), spawn "mediacontrol prev")
		, ((0                     , 0x1008FF17), spawn "mediacontrol next")
		, ((0                     , xK_Print), spawn "scrot $HOME/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1")
		, ((mod4Mask              , xK_l), sendMessage $ Go R)
		, ((mod4Mask              , xK_h), sendMessage $ Go L)
		, ((mod4Mask              , xK_k), sendMessage $ Go U)
		, ((mod4Mask              , xK_j), sendMessage $ Go D)
		, ((mod4Mask .|. shiftMask, xK_l), sendMessage $ Swap R)
		, ((mod4Mask .|. shiftMask, xK_h), sendMessage $ Swap L)
		, ((mod4Mask .|. shiftMask, xK_k), sendMessage $ Swap U)
		, ((mod4Mask .|. shiftMask, xK_j), sendMessage $ Swap D)
		, ((mod4Mask .|. shiftMask, xK_comma), sendMessage Shrink)
		, ((mod4Mask .|. shiftMask, xK_period), sendMessage Expand)
		]
