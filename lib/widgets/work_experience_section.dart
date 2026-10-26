import 'package:cv_web_app/models/work_experience_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/work_experience.dart';

const _primary = Color(0xFF6366F1);
const _textDark = Color(0xFF1F2937);
const _textBody = Color(0xFF374151);
const _textMuted = Color(0xFF6B7280);
const _currentGreen = Color(0xFF10B981);

class WorkExperienceSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final Animation<double> workExperienceAnimation;

  const WorkExperienceSection({super.key, required this.sectionKey, required this.workExperienceAnimation});

  @override
  State<WorkExperienceSection> createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  static const int _initialCount = 3;
  int _displayedExperiences = _initialCount;
  // Index of the first card of the latest "show more" batch, used to stagger only the new cards
  int _batchStart = 0;

  final List<WorkExperience> workExperiences = jsonWorkExperiences.map((element) => WorkExperience.fromJson(element)).toList();

  int get _yearsOfExperience {
    final years = workExperiences.map((e) => e.startYear).whereType<int>();
    if (years.isEmpty) return 0;
    return DateTime.now().year - years.reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final visibleCount = _displayedExperiences.clamp(0, workExperiences.length);

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 100 : 60, horizontal: isDesktop ? 40 : 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF9FAFB), Color(0xFFF3F4F6)]),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildHeader(isDesktop),
              SizedBox(height: isDesktop ? 60 : 40),
              Column(
                children: List.generate(visibleCount, (index) {
                  return _RevealIn(
                    key: ValueKey(workExperiences[index].company + workExperiences[index].duration),
                    trigger: widget.workExperienceAnimation,
                    delay: Duration(milliseconds: 140 * (index - _batchStart).clamp(0, 10)),
                    child: WorkExperienceCard(
                      workExperience: workExperiences[index],
                      nextColor: index + 1 < visibleCount ? workExperiences[index + 1].color : null,
                      isLast: index == visibleCount - 1,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              _buildToggleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.briefcase, size: 12, color: _primary),
              const SizedBox(width: 8),
              Text(
                'CAREER JOURNEY',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _primary, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Work Experience',
          style: GoogleFonts.inter(fontSize: isDesktop ? 48 : 32, fontWeight: FontWeight.w700, color: _textDark, letterSpacing: -1),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'My professional journey and career highlights',
          style: GoogleFonts.inter(fontSize: isDesktop ? 18 : 16, color: _textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatTile(animation: widget.workExperienceAnimation, value: _yearsOfExperience, suffix: '+', label: 'Years of experience'),
            _StatTile(animation: widget.workExperienceAnimation, value: workExperiences.length, label: 'Roles'),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    final hasMore = _displayedExperiences < workExperiences.length;
    if (!hasMore && workExperiences.length <= _initialCount) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: Tween(begin: 0.9, end: 1.0).animate(animation), child: child),
      ),
      child: _HoverButton(
        key: ValueKey(hasMore),
        label: hasMore ? 'Show More Experience (${workExperiences.length - _displayedExperiences} remaining)' : 'Show Less',
        icon: hasMore ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
        onPressed: () {
          setState(() {
            if (hasMore) {
              _batchStart = _displayedExperiences;
              _displayedExperiences = (_displayedExperiences + 2).clamp(0, workExperiences.length);
            } else {
              _batchStart = 0;
              _displayedExperiences = _initialCount;
              Scrollable.ensureVisible(widget.sectionKey.currentContext!, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
            }
          });
        },
      ),
    );
  }
}

class WorkExperienceCard extends StatefulWidget {
  final WorkExperience workExperience;
  final Color? nextColor;
  final bool isLast;

  const WorkExperienceCard({super.key, required this.workExperience, this.nextColor, this.isLast = false});

  @override
  State<WorkExperienceCard> createState() => _WorkExperienceCardState();
}

class _WorkExperienceCardState extends State<WorkExperienceCard> {
  static const int _collapsedResponsibilities = 3;

  bool _isHovered = false;
  bool _isExpanded = false;

  WorkExperience get _exp => widget.workExperience;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final iconSize = isDesktop ? 72.0 : 52.0;
    final gap = isDesktop ? 28.0 : 14.0;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          children: [
            // Timeline line connecting to the next card, drawn in as the card reveals
            if (!widget.isLast)
              Positioned(
                left: iconSize / 2 - 1,
                top: iconSize + 12,
                bottom: 0,
                child: _TimelineLine(from: _exp.color, to: widget.nextColor ?? _exp.color, progress: _RevealIn.of(context)),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompanyIcon(experience: _exp, size: iconSize, isHovered: _isHovered),
                  SizedBox(width: gap),
                  Expanded(child: _buildCard(isDesktop)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(bool isDesktop) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _isHovered ? _exp.color.withValues(alpha: 0.18) : Colors.black.withValues(alpha: 0.06),
            blurRadius: _isHovered ? 32 : 18,
            offset: Offset(0, _isHovered ? 16 : 6),
          ),
        ],
        border: Border.all(color: _isHovered ? _exp.color.withValues(alpha: 0.35) : Colors.grey.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Accent bar that grows on hover
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _isHovered ? 6 : 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_exp.color, _exp.color.withValues(alpha: 0.3)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(isDesktop ? 30 : 22, isDesktop ? 26 : 20, isDesktop ? 26 : 18, isDesktop ? 26 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(isDesktop),
                  const SizedBox(height: 14),
                  _buildMeta(),
                  const SizedBox(height: 16),
                  Text(
                    _exp.description,
                    style: GoogleFonts.inter(fontSize: isDesktop ? 15 : 14, color: _textBody, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  _buildResponsibilities(),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _exp.technologies.map((tech) => _TechChip(label: tech.trim(), color: _exp.color)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(bool isDesktop) {
    final hasUrl = _exp.companyUrl != null;
    final badges = [if (_exp.isCurrent) const _CurrentBadge(), _Badge(label: _exp.employmentType, color: _exp.color)];

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: hasUrl ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            onTap: hasUrl ? () => _launchURL(_exp.companyUrl!) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _exp.company,
                    style: GoogleFonts.inter(fontSize: isDesktop ? 22 : 18, fontWeight: FontWeight.w700, color: _textDark),
                  ),
                ),
                if (hasUrl) ...[const SizedBox(width: 6), FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 12, color: _exp.color)],
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _exp.position,
          style: GoogleFonts.inter(fontSize: isDesktop ? 16 : 14, fontWeight: FontWeight.w600, color: _exp.color),
        ),
      ],
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: badges),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: title),
        const SizedBox(width: 12),
        Wrap(spacing: 8, runSpacing: 8, children: badges),
      ],
    );
  }

  Widget _buildMeta() {
    final tenure = _exp.tenure;
    return Wrap(
      spacing: 18,
      runSpacing: 8,
      children: [
        _MetaItem(icon: Icons.calendar_today_rounded, text: tenure != null ? '${_exp.duration}  ·  $tenure' : _exp.duration),
        _MetaItem(icon: Icons.location_on_rounded, text: _exp.location),
      ],
    );
  }

  Widget _buildResponsibilities() {
    final all = _exp.responsibilities;
    final canExpand = all.length > _collapsedResponsibilities;
    final visible = _isExpanded || !canExpand ? all : all.take(_collapsedResponsibilities).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Key Responsibilities',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _textBody),
            ),
            if (canExpand) ...[
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Show Less' : 'Show All',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _exp.color),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down, size: 16, color: _exp.color),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            children: visible
                .map(
                  (responsibility) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(color: _exp.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                          child: Icon(Icons.check_rounded, size: 12, color: _exp.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(responsibility, style: GoogleFonts.inter(fontSize: 14, color: _textMuted, height: 1.5)),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// Fades and slides its child in once [trigger] starts, after [delay].
/// Descendants can read the reveal progress through [_RevealIn.of].
class _RevealIn extends StatefulWidget {
  final Animation<double> trigger;
  final Duration delay;
  final Widget child;

  const _RevealIn({super.key, required this.trigger, required this.delay, required this.child});

  static Animation<double> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RevealScope>()?.animation ?? kAlwaysCompleteAnimation;

  @override
  State<_RevealIn> createState() => _RevealInState();
}

class _RevealInState extends State<_RevealIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  bool _started = false;

  @override
  void initState() {
    super.initState();
    if (widget.trigger.status != AnimationStatus.dismissed) {
      _start();
    } else {
      widget.trigger.addStatusListener(_onTriggerStatus);
    }
  }

  void _onTriggerStatus(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) {
      widget.trigger.removeStatusListener(_onTriggerStatus);
      _start();
    }
  }

  Future<void> _start() async {
    if (_started) return;
    _started = true;
    await Future.delayed(widget.delay);
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    widget.trigger.removeStatusListener(_onTriggerStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RevealScope(
      animation: _curve,
      child: FadeTransition(
        opacity: _curve,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(_curve),
          child: widget.child,
        ),
      ),
    );
  }
}

class _RevealScope extends InheritedWidget {
  final Animation<double> animation;

  const _RevealScope({required this.animation, required super.child});

  @override
  bool updateShouldNotify(_RevealScope oldWidget) => animation != oldWidget.animation;
}

class _TimelineLine extends StatelessWidget {
  final Color from;
  final Color to;
  final Animation<double> progress;

  const _TimelineLine({required this.from, required this.to, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) => Align(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        child: FractionallySizedBox(
          heightFactor: progress.value,
          alignment: Alignment.topCenter,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [from.withValues(alpha: 0.7), to.withValues(alpha: 0.4)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyIcon extends StatefulWidget {
  final WorkExperience experience;
  final double size;
  final bool isHovered;

  const _CompanyIcon({required this.experience, required this.size, required this.isHovered});

  @override
  State<_CompanyIcon> createState() => _CompanyIconState();
}

class _CompanyIconState extends State<_CompanyIcon> with SingleTickerProviderStateMixin {
  // Only the current role gets a pulsing halo
  late final AnimationController? _pulse = widget.experience.isCurrent
      ? (AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat())
      : null;

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.experience.color;
    final size = widget.size;

    final tile = AnimatedScale(
      scale: widget.isHovered ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      child: AnimatedRotation(
        turns: widget.isHovered ? -0.02 : 0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, Color.lerp(color, Colors.black, 0.25)!]),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: widget.isHovered ? 0.5 : 0.3),
                blurRadius: widget.isHovered ? 24 : 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(widget.experience.icon, size: size * 0.4, color: Colors.white),
          ),
        ),
      ),
    );

    final pulse = _pulse;
    if (pulse == null) return tile;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: pulse,
            builder: (context, _) {
              final t = Curves.easeOut.transform(pulse.value);
              return Transform.scale(
                scale: 1 + t * 0.35,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size * 0.28),
                    border: Border.all(color: color.withValues(alpha: (1 - t) * 0.6), width: 2),
                  ),
                ),
              );
            },
          ),
          tile,
        ],
      ),
    );
  }
}

class _CurrentBadge extends StatefulWidget {
  const _CurrentBadge();

  @override
  State<_CurrentBadge> createState() => _CurrentBadgeState();
}

class _CurrentBadgeState extends State<_CurrentBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _currentGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _currentGreen.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween(begin: 0.35, end: 1.0).animate(_controller),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: _currentGreen, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Current',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _currentGreen),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: _textMuted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w500, color: _textMuted),
          ),
        ),
      ],
    );
  }
}

class _TechChip extends StatefulWidget {
  final String label;
  final Color color;

  const _TechChip({required this.label, required this.color});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: _isHovered ? 1 : 0.2)),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: _isHovered ? Colors.white : color),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final Animation<double> animation;
  final int value;
  final String suffix;
  final String label;

  const _StatTile({required this.animation, required this.value, this.suffix = '', required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 768 ? 180 : 150,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Counts up when the section animation runs
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) => ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [_primary, Color(0xFF8B5CF6)]).createShader(bounds),
              child: Text(
                '${(value * animation.value).round()}$suffix',
                style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: _textMuted),
          ),
        ],
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _HoverButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_primary, Color(0xFF8B5CF6)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              AnimatedSlide(
                offset: Offset(0, _isHovered ? 0.15 : 0),
                duration: const Duration(milliseconds: 200),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
