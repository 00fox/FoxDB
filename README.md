Please consider supporting the project by clicking [![Github Sponsorship](.github/Sponsors.gif)](https://github.com/sponsors/00fox)

**Opened Issues, please report bugs, problems (ot issues@00fox.com)**

# FoxDB manages the SavedVariables of your addons, with EditMode included. (For World of Warcraft)
version 11.0.2.0

You will be able to save variables depending on the template the user is in,
not just globals and characters, and this, in an automated way in EditMode,
and in a much simpler way than before,
moreover, there is no need for any other library to create a complete addon, except very specific ones.

Written in clean language and optimized code,
- the goal of starting from scratch, in addition to EditMode,
  is to not let the addon go through a full chain of dependencies,
  having hundreds of lines of code actions before the next, each.
  ( and avoid too many unnecessary encapsulations )
  Priority: quick launch, memory, intelligible code.

This system is not in conflict with the systems already in place,
- so you will not encounter any problem when using it for a new addon,
  to make a transition from an old one or to keep an old one as it is.

You of course still have access to a simplified version of the profiles;
-  otherwise, this part remains dormant.

If you come from an already made addon in a classic way (global+profiles),
-  the transition exists internally to change these things
    and keep the defaults in each profile that used it,
    after which there is no longer a default profile.
-  The final goal being to use the globals,
    the layout (instead of the profile)
    and the profile for the few variables which remain necessary to be specific to each character.
-  But in the meantime, your base will continue to function as before,
    as long as you don't start using the layouts yourself.

Additional Content:
-  SavedVariable files are also written during /reload
  Layout management is fully automated, user access is not required, but some things are still doable.
-  No nightmares with default databases,
    you define variables in a function if they don't already exist on loading,
    you do what you need when the layout/profile is changed/reset in another.
-  Register one or several chat commands
    and receive the arguments already split into a function.
-  Possibility of an Minimap icon, in ultra light code, without any inconvenience if not used
    Player's EditMode support to manage them include visibility, so not conflicting with AddonCompartment.

EditMode:
-  Addons that use EditMode receive a simplified common support for the correct functioning of all (addons and system).
-  Automatic frame registration.
-  Automatic showing/hidding frames when entering/exiting EditMode.
-  Automatic hidding system menus and highlighting frames.
-  Receive a callback when a frame is clicked to hide/show your menu.

Note:
-	You manually start your addon, then load the data base, which will tell you when the layouts are ready;
	 you therefore control everything with a feeling of the early days of wow.

## The instructions are contained in the file itself

## You can find a complete example of an addon that uses it here: (soon)
