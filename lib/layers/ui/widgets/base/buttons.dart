import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';

class ThemedRaisedButton extends StatelessWidget {
  final AppButtonTheme buttonTheme;
  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final ButtonTextTheme textTheme;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final Brightness colorBrightness;
  final double elevation;
  final double focusElevation;
  final double hoverElevation;
  final double highlightElevation;
  final double disabledElevation;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final FocusNode focusNode;
  final bool autofocus;
  final MaterialTapTargetSize materialTapTargetSize;
  final Duration animationDuration;
  final Widget child;

  const ThemedRaisedButton({
    Key key,
    @required this.buttonTheme,
    @required this.onPressed,
    this.onHighlightChanged,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.padding,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.animationDuration,
    this.child,
  }) : assert(buttonTheme != null);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buttonTheme.themeData,
      child: RaisedButton(
        onPressed: this.onPressed,
        onHighlightChanged: this.onHighlightChanged,
        textTheme: this.textTheme,
        textColor: this.textColor,
        disabledTextColor: this.disabledTextColor,
        color: this.color,
        disabledColor: this.disabledColor,
        focusColor: this.focusColor,
        hoverColor: this.hoverColor,
        highlightColor: this.highlightColor,
        splashColor: this.splashColor,
        colorBrightness: this.colorBrightness,
        elevation: this.elevation ?? this.buttonTheme.elevation.elevation,
        focusElevation: this.focusElevation ?? this.buttonTheme.elevation.focusElevation,
        hoverElevation: this.hoverElevation ?? this.buttonTheme.elevation.hoverElevation,
        highlightElevation: this.highlightElevation ?? this.buttonTheme.elevation.highlightElevation,
        disabledElevation: this.disabledElevation ?? this.buttonTheme.elevation.disabledElevation,
        padding: this.padding,
        shape: this.shape,
        clipBehavior: this.clipBehavior,
        focusNode: this.focusNode,
        autofocus: this.autofocus,
        materialTapTargetSize: this.materialTapTargetSize,
        animationDuration: this.animationDuration,
        child: this.child,
      ),
    );
  }
}

class CustomShadowButton extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final ShapeBorder shape;

  bool get enabled => onPressed != null;

  const CustomShadowButton({
    Key key,
    this.child,
    this.onPressed,
    this.onHighlightChanged,
    this.focusNode,
    this.autofocus = false,
    this.shape,
  }) : super(key: key);

  @override
  _CustomShadowButtonState createState() => _CustomShadowButtonState();
}

class _CustomShadowButtonState extends State<CustomShadowButton> {
  final Set<MaterialState> _states = <MaterialState>{};

  bool get _hovered => _states.contains(MaterialState.hovered);

  bool get _focused => _states.contains(MaterialState.focused);

  bool get _pressed => _states.contains(MaterialState.pressed);

  bool get _disabled => _states.contains(MaterialState.disabled);

  void _updateState(MaterialState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  void _handleHighlightChanged(bool value) {
    if (_pressed != value) {
      setState(() {
        _updateState(MaterialState.pressed, value);
        if (widget.onHighlightChanged != null) {
          widget.onHighlightChanged(value);
        }
      });
    }
  }

  void _handleHoveredChanged(bool value) {
    if (_hovered != value) {
      setState(() {
        _updateState(MaterialState.hovered, value);
      });
    }
  }

  void _handleFocusedChanged(bool value) {
    if (_focused != value) {
      setState(() {
        _updateState(MaterialState.focused, value);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState(MaterialState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(CustomShadowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(MaterialState.disabled, !widget.enabled);

    if (_disabled && _pressed) {
      _handleHighlightChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShapeBorder effectiveShape =
        MaterialStateProperty.resolveAs<ShapeBorder>(
      widget.shape,
      _states,
    );

    final button = Focus(
      focusNode: widget.focusNode,
      onFocusChange: _handleFocusedChanged,
      autofocus: widget.autofocus,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Color(0xFF979797),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 14,
              color: Color.fromARGB(72, 75, 0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () {},
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: button,
    );
  }
}
