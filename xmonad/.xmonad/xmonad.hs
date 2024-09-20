{-# LANGUAGE RecordWildCards #-}

import XMonad
import XMonad.StackSet (Stack(..))
import qualified XMonad.StackSet as W

import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.MultiToggle
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.WindowNavigation
import XMonad.Util.Cursor
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

import Data.List (isInfixOf)
import Data.Map (Map, fromList)
import Graphics.X11.ExtraTypes.XF86
import System.Exit (exitSuccess)

main :: IO ()
main = xmonad . addEwmhWorkspaceSort filterScratchpads . ewmh . docks $ def
    { clickJustFocuses   = False
    , focusFollowsMouse  = False
    , focusedBorderColor = "#cba6f7" -- mauve
    , normalBorderColor  = "#11111b" -- crust
    , keys               = keybindings
    , layoutHook         = layoutHooks
    , manageHook         = manageHooks
    , startupHook        = startupHooks
    , workspaces         = ["1"]
    , terminal           = "alacritty"
    } where filterScratchpads = return (filterOutWs [scratchpadWorkspaceTag])

manageHooks :: ManageHook
manageHooks = composeAll
    [ insertPosition End Newer
    , isDialog --> doCenterFloat
    , isFullscreen --> doFullFloat
    , namedScratchpadManageHook scratchpads
    ]

scratchpads :: NamedScratchpads
scratchpads =
    [ NS "terminal"  "alacritty --title nsp-terminal" (title =? "nsp-terminal")
        (customFloating $ W.RationalRect (1/4) (1/6) (1/2) (2/3)) -- x, y, w, h
    , NS "translate" "alacritty --title nsp-translate -e trans -shell" (title =? "nsp-translate")
        (customFloating $ W.RationalRect (1/3) (1/3) (1/3) (1/3)) -- x, y, w, h
    ]

layoutHooks = smartBorders $
    avoidStruts (reflectHoriz (tallSub ||| twoPane)) ||| fullscreenFull Full
    where tall = ResizableTall 1 (3/100) (1/2) []
          tallSub = windowNavigation (subLayout [0,1] (Simplest ||| Grid) tall)
          twoPane = TwoPanePersistent Nothing (3/100) (1/2)

startupHooks :: X ()
startupHooks = spawn "~/bin/polybar.sh" >> setDefaultCursor xC_left_ptr

-- cycle focus up/down off master
focusDown = W.modify' (rotateStack (\l -> [last l] ++ (init l)))
focusUp   = W.modify' (rotateStack (\l -> (tail l) ++ [head l]))

rotateStack :: ([a] -> [a]) -> Stack a -> Stack a
rotateStack _ (Stack w [] []) = Stack w [] []
rotateStack _ (Stack w [] (x:xs)) = Stack x [w] xs
rotateStack f (Stack w ls rs) = Stack w' (reverse ls') rs'
    where (master:subs) = reverse ls ++ w : rs
          (ls', w':rs') = splitAt (length ls) (master:f subs)

ifLayout :: String -> a -> a -> X a
ifLayout label t f = do
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
    -- spawn floating terminal
    , ((modMask,               xK_BackSpace), namedScratchpadAction scratchpads "terminal")
    -- spawn floating translator
    , ((modMask,               xK_u        ), namedScratchpadAction scratchpads "translate")
    -- spawn terminal
    , ((modMask .|. shiftMask, xK_Return   ), spawn terminal)
    -- close focused window
    , ((modMask .|. shiftMask, xK_q        ), kill1)
    -- rotate through the available layouts
    , ((modMask,               xK_space    ), sendMessage NextLayout)
    -- rotate through the available sublayouts
    , ((ctrlMask,              xK_space    ), toSubl NextLayout)
    -- move focus to the next window
    , ((modMask,               xK_t        ), windows =<< ifLayout "TwoPane" focusDown W.focusDown)
    -- move focus to the prevous window
    , ((modMask,               xK_n        ), windows =<< ifLayout "TwoPane" focusUp W.focusUp)
    -- move focus to the master window;
    , ((modMask,               xK_m        ), windows W.focusMaster)
    -- swap focused window and master window
    , ((modMask,               xK_Return   ), windows W.swapMaster)
    -- swap focused window and next window
    , ((modMask .|. shiftMask, xK_t        ), windows W.swapDown)
    -- swap focused window and previous window
    , ((modMask .|. shiftMask, xK_n        ), windows W.swapUp)
    -- merge focused window down into sublayout
    , ((modMask .|. ctrlMask,  xK_t        ), sendMessage (pullGroup D))
    -- merge focused window up into sublayout
    , ((modMask .|. ctrlMask,  xK_n        ), sendMessage (pullGroup U))
    -- unmerge windows from sublayout
    , ((modMask,               xK_g        ), withFocused (sendMessage . UnMerge))
    -- shrink the master area
    , ((modMask,               xK_h        ), sendMessage =<< ifLayout "ReflectX" Expand Shrink)
    -- expand the master area
    , ((modMask,               xK_s        ), sendMessage =<< ifLayout "ReflectX" Shrink Expand)
    -- shrink the stack area
    , ((modMask .|. shiftMask, xK_h        ), sendMessage MirrorShrink)
    -- expand the stack area
    , ((modMask .|. shiftMask, xK_s        ), sendMessage MirrorExpand)
    -- sink focused floating window
    , ((modMask,               xK_f        ), withFocused (windows . W.sink))
    -- restart xmonad
    , ((modMask .|. shiftMask, xK_r        ), spawn "xmonad --recompile && xmonad --restart")
    -- kill xmonad and X11
    , ((modMask .|. shiftMask, xK_Escape   ), liftIO exitSuccess)
    -- move to next workspace
    , ((winMask,               xK_Return   ), removeEmptyWorkspaceAfter (move Next))
    -- move to previous workspace
    , ((winMask,               xK_BackSpace), removeEmptyWorkspaceAfter (move Prev))
    -- bring window to next workspace
    , ((winMask .|. shiftMask, xK_Return   ), removeEmptyWorkspaceAfter (shift Next >> move Next))
    -- bring window to previous workspace
    , ((winMask .|. shiftMask, xK_BackSpace), removeEmptyWorkspaceAfter (shift Prev >> move Prev))
    -- media bindings
    , ((0, xF86XK_AudioLowerVolume), spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+")
    , ((0, xF86XK_AudioPlay), spawn "mpc toggle")
    , ((0, xF86XK_AudioPrev), spawn "mpc prev")
    , ((0, xF86XK_AudioNext), spawn "mpc next")
    , ((0, xF86XK_AudioStop), spawn "mpc stop")
    ] ++
    -- win-[1..9]: move to workspace N
    -- win-ctrl-[1..9]: copy window to workspace N
    -- win-shift-[1..9]: move window to workspace N
    [((winMask .|. m, k), removeEmptyWorkspaceAfter (withHiddenWorkspace f (show i))) |
        (i, k) <- zip [1..] [xK_1..xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, ctrlMask)]
    ] where withHiddenWorkspace f i = addHiddenWorkspace i >> windows (f i)

shift d = shiftTo d (ignoringWSs [scratchpadWorkspaceTag])
move  d = moveTo  d (ignoringWSs [scratchpadWorkspaceTag])
