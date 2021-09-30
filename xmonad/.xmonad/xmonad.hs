{-# LANGUAGE RecordWildCards #-}

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.DynamicWorkspaces
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isDialog, doCenterFloat)
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts hiding (subTabbed)
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.WindowNavigation
import XMonad.Util.Cursor

import Data.List (isInfixOf)
import Data.Map (Map, fromList)
import Graphics.X11.ExtraTypes.XF86
import System.Exit (exitSuccess)

import XMonad.StackSet (Stack(..))
import qualified XMonad.StackSet as W

main :: IO ()
main = xmonad . fullscreenSupport . docks $ ewmh def
    { clickJustFocuses   = False
    , focusFollowsMouse  = False
    , focusedBorderColor = "#aeddff"
    , normalBorderColor  = "#181818"
    , keys               = keybindings
    , layoutHook         = layoutHooks
    , manageHook         = manageHooks
    , startupHook        = startupHooks
    , workspaces         = ["1"]
    , terminal           = "alacritty"
    }

manageHooks = isDialog --> doCenterFloat

layoutHooks = smartBorders . mkToggle1 REFLECTX $
    avoidStruts (tallTab ||| twoPane) ||| fullscreenFull Full
    where tall = ResizableTall 1 (3/100) (1/2) []
          tallTab = windowNavigation (subtabbed tall)
          twoPane = TwoPanePersistent Nothing (3/100) (1/2)

subtabbed = addTabs shrinkText tabConfig . subLayout [] Simplest
    where tabConfig = def
              { fontName            = "xft:Hack Nerd Font"
              , activeColor         = "#aeddff"
              , activeTextColor     = "#aeddff"
              , activeBorderColor   = "#aeddff"
              , inactiveColor       = "#1e282d"
              , inactiveTextColor   = "#1e282d"
              , inactiveBorderColor = "#1e282d"
              , urgentTextColor     = "#ff262b"
              }

startupHooks :: X ()
startupHooks = do
    spawn "~/bin/polybar.sh"
    setDefaultCursor xC_left_ptr

-- cycle focus up/down off master
focusDown = W.modify' $ rotateStack (\l -> [last l] ++ (init l))
focusUp   = W.modify' $ rotateStack (\l -> (tail l) ++ [head l])

rotateStack :: ([a] -> [a]) -> Stack a -> Stack a
rotateStack _ (Stack w [] []) = Stack w [] []
rotateStack _ (Stack w [] (x:xs)) = Stack x [w] xs
rotateStack f (Stack w ls rs) = Stack w' (reverse ls') rs'
    where (master:subs) = reverse ls ++ w : rs
          (ls', w':rs') = splitAt (length ls) (master:f subs)

ifeLayout :: String -> a -> a -> X a
ifeLayout label t f = do
    layout <- gets (W.layout . W.workspace . W.current . windowset)
    return $ if isInfixOf label (description layout) then t else f

winMask :: KeyMask
winMask = mod4Mask

ctrlMask :: KeyMask
ctrlMask = controlMask

keybindings :: XConfig l -> Map (KeyMask, KeySym) (X ())
keybindings XConfig{..} = Data.Map.fromList $
    [ ((modMask,               xK_p        ), spawn "rofi -show run")
    , ((modMask,               xK_Tab      ), spawn "rofi -show window")
    , ((modMask .|. shiftMask, xK_Return   ), spawn terminal)
    -- unmerge windows out of sublayout
    , ((modMask,               xK_g        ), withFocused (sendMessage . UnMerge))
    -- merge all windows into sublayout
    , ((modMask .|. shiftMask, xK_g        ), withFocused (sendMessage . MergeAll))
    -- close focused window
    , ((modMask .|. shiftMask, xK_q        ), kill1)
    -- rotate through the available layout algorithms
    , ((modMask,               xK_space    ), sendMessage NextLayout)
    -- toggle horizontal layout mirroring
    , ((controlMask,           xK_space    ), sendMessage (Toggle REFLECTX))
    -- move focus to the next window
    , ((modMask,               xK_t        ), windows =<< ifeLayout "TwoPane" focusDown W.focusDown)
    -- move focus to the prevous window
    , ((modMask,               xK_n        ), windows =<< ifeLayout "TwoPane" focusUp W.focusUp)
    -- move focus to the master window;
    , ((modMask,               xK_m        ), windows W.focusMaster)
    -- swap focused window and master window
    , ((modMask,               xK_Return   ), windows W.swapMaster)
    -- swap focused window and next window
    , ((modMask .|. shiftMask, xK_t        ), windows W.swapDown)
    -- swap focused window and previous window
    , ((modMask .|. shiftMask, xK_n        ), windows W.swapUp)
    -- pull focused window down into group
    , ((modMask .|. ctrlMask,  xK_t        ), sendMessage (pullGroup D))
    -- pull focused window up into group
    , ((modMask .|. ctrlMask,  xK_n        ), sendMessage (pullGroup U))
    -- shrink the master area
    , ((modMask,               xK_h        ), sendMessage =<< ifeLayout "ReflectX" Expand Shrink)
    -- expand the master area
    , ((modMask,               xK_s        ), sendMessage =<< ifeLayout "ReflectX" Shrink Expand)
    -- shrink the stack area
    , ((modMask .|. shiftMask, xK_h        ), sendMessage MirrorShrink)
    -- expand the stack area
    , ((modMask .|. shiftMask, xK_s        ), sendMessage MirrorExpand)
    -- sink floating window
    , ((modMask,               xK_f        ), withFocused (windows . W.sink))
    -- restart xmonad
    , ((modMask .|. shiftMask, xK_r        ), spawn "xmonad --recompile && xmonad --restart")
    -- kill xmonad and X11
    , ((modMask .|. shiftMask, xK_Escape   ), liftIO exitSuccess)
    -- move to next workspace
    , ((winMask,               xK_Return   ), removeEmptyWorkspaceAfter nextWS)
    -- move to previous workspace
    , ((winMask,               xK_BackSpace), removeEmptyWorkspaceAfter prevWS)
    -- bring window to next workspace
    , ((winMask .|. shiftMask, xK_Return   ), removeEmptyWorkspaceAfter (shiftToNext >> nextWS))
    -- bring window to previous workspace
    , ((winMask .|. shiftMask, xK_BackSpace), removeEmptyWorkspaceAfter (shiftToPrev >> prevWS))
    -- media bindings
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%- toggle unmute")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+ toggle unmute")
    , ((0, xF86XK_AudioPlay), spawn "mpc toggle")
    , ((0, xF86XK_AudioPrev), spawn "mpc prev")
    , ((0, xF86XK_AudioNext), spawn "mpc next")
    , ((0, xF86XK_AudioStop), spawn "mpc stop")
    ] ++
    -- win-[1..9]: move to workspace N
    -- win-ctrl-[1..9]: copy window to workspace N
    -- win-shift-[1..9]: bring window to workspace N
    [((winMask .|. m, k), removeEmptyWorkspaceAfter (withHiddenWorkspace f (show i))) |
        (i, k) <- zip [1..] [xK_1..xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, ctrlMask)]
    ]
        where withHiddenWorkspace f i = addHiddenWorkspace i >> windows (f i)
