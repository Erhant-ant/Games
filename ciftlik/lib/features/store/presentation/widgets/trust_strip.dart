import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
class TrustStrip extends StatelessWidget { const TrustStrip({super.key});
  @override Widget build(BuildContext context) { final s=AppLocalizations.of(context); return Container(color: AppColors.sand, padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20), child: Wrap(alignment: WrapAlignment.center, spacing: 34, runSpacing: 15, children: [_Trust(Icons.eco_outlined,s.text('trustSeasonal')),_Trust(Icons.volunteer_activism_outlined,s.text('trustNatural')),_Trust(Icons.inventory_2_outlined,s.text('trustPacked')),_Trust(Icons.local_shipping_outlined,s.text('trustDelivery'))])); } }
class _Trust extends StatelessWidget { const _Trust(this.icon,this.text); final IconData icon; final String text;
  @override Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children:[Icon(icon,color:AppColors.olive,size:21),const SizedBox(width:8),Text(text,style:const TextStyle(fontWeight:FontWeight.w600,fontSize:13,color:AppColors.ink))]); }
