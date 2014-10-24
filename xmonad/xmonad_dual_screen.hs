import Data.List
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import System.IO
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.EwmhDesktops

myWorkspaces = withScreens 2 $ ["1:main","2:xp","3:py","4:mail"] ++ map show [5..9]

myManageHooks = manageDocks <+> manageHook defaultConfig <+> composeAll [ isFullscreen --> doFullFloat ]

myLayoutHooks = smartBorders $ avoidStruts ( tiled ||| Mirror tiled ||| noBorders (fullscreenFull Full))
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

--keyBindings conf = let m = modMask conf in fromList $
--           [((m .|. modm, k), windows $ onCurrentScreen f i)
--            | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
--            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

--keyBindings conf = let m = modMask conf in fromList $
--          [((m .|. modm, k), windows $ f i)
--         | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
--          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


--myKeys = [
--         ((m .|. mod4Mask, k), windows $ onCurrentScreen f i)
--              | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
--              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
--         ]

conf = defaultConfig { workspaces = myWorkspaces}

myKeys = [
	 ((m .|. mod4Mask, k), windows $ onCurrentScreen f i)
	      | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
	      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
	 ]
	  ++
	[((mod4Mask .|. shiftMask, xK_l), spawn "slock")
	, ((0                     , 0x1008FF11), spawn "change_volume 2-")
	, ((0                     , 0x1008FF13), spawn "change_volume 2+")
	, ((0                     , 0x1008FF12), spawn "change_volume toggle")
	, ((0                     , 0x1008FF14), spawn "qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Pause")
	, ((0                     , 0x1008FF16), spawn "qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Prev")
	, ((0                     , 0x1008FF17), spawn "qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Next")
	, ((0                     , xK_Print), spawn "scrot $HOME/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1")
	]

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
		} `additionalKeys` myKeys
