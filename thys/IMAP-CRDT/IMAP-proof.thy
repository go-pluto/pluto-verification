theory
  "IMAP-proof"
imports
  "IMAP-def"
  "IMAP-proof-commute"
  "IMAP-proof-helpers"
  "IMAP-proof-independent"
begin

corollary (in imap) concurrent_add_remove_independent:
  assumes "\<not> hb (i, Add i e1) (ir, Rem is e2)" and "\<not> hb (ir, Rem is e2) (i, Add i e1)"
    and "xs prefix of j"
    and "(i, Add i e1) \<in> set (node_deliver_messages xs)" and "(ir, Rem is e2) \<in> set (node_deliver_messages xs)"
  shows "i \<notin> is"
  using assms add_rem_ids_imply_messages_same concurrent_add_remove_independent_technical by fastforce
  	
corollary (in imap) concurrent_append_remove_independent:
  assumes "\<not> hb (i, Append i e1) (ir, Rem is e2)" and "\<not> hb (ir, Rem is e2) (i, Append i e1)"
    and "xs prefix of j"
    and "(i, Append i e1) \<in> set (node_deliver_messages xs)" and "(ir, Rem is e2) \<in> set (node_deliver_messages xs)"
  shows "i \<notin> is"
  using assms append_rem_ids_imply_messages_same concurrent_append_remove_independent_technical by fastforce
  	
corollary (in imap) concurrent_append_expunge_independent:
  assumes "\<not> hb (i, Append i e1) (r, Expunge e2 mo r)" and "\<not> hb (r, Expunge e2 mo r) (i, Append i e1)"
    and "xs prefix of j"
    and "(i, Append i e1) \<in> set (node_deliver_messages xs)" and "(r, Expunge e2 mo r) \<in> set (node_deliver_messages xs)"
  shows "i \<noteq> mo"
  using assms append_expunge_ids_imply_messages_same concurrent_append_expunge_independent_technical by fastforce
  	
corollary (in imap) concurrent_append_store_independent:
  assumes "\<not> hb (i, Append i e1) (r, Store e2 mo r)" and "\<not> hb (r, Store e2 mo r) (i, Append i e1)"
    and "xs prefix of j"
    and "(i, Append i e1) \<in> set (node_deliver_messages xs)" and "(r, Store e2 mo r) \<in> set (node_deliver_messages xs)"
  shows "i \<noteq> mo"
  using assms append_store_ids_imply_messages_same concurrent_append_store_independent_technical by fastforce
    
corollary (in imap) concurrent_expunge_remove_independent:
  assumes "\<not> hb (i, Expunge e1 mo i) (ir, Rem is e2)" and "\<not> hb (ir, Rem is e2) (i, Expunge e1 mo i)"
    and "xs prefix of j"
    and "(i, Expunge e1 mo i) \<in> set (node_deliver_messages xs)" and "(ir, Rem is e2) \<in> set (node_deliver_messages xs)"
  shows "i \<notin> is"
  using assms expunge_rem_ids_imply_messages_same concurrent_expunge_remove_independent_technical by fastforce
  	
corollary (in imap) concurrent_store_remove_independent:
  assumes "\<not> hb (i, Store e1 mo i) (ir, Rem is e2)" and "\<not> hb (ir, Rem is e2) (i, Store e1 mo i)"
    and "xs prefix of j"
    and "(i, Store e1 mo i) \<in> set (node_deliver_messages xs)" and "(ir, Rem is e2) \<in> set (node_deliver_messages xs)"
  shows "i \<notin> is"
  using assms store_rem_ids_imply_messages_same concurrent_store_remove_independent_technical by fastforce
  	
corollary (in imap) concurrent_store_expunge_independent:
  assumes "\<not> hb (i, Store e1 mo i) (r, Expunge e2 mo2 r)" and "\<not> hb (r, Expunge e2 mo2 r) (i, Store e1 mo i)"
    and "xs prefix of j"
    and "(i, Store e1 mo i) \<in> set (node_deliver_messages xs)" and "(r, Expunge e2 mo2 r) \<in> set (node_deliver_messages xs)"
  shows "i \<noteq> mo2 \<and> r \<noteq> mo"
  using assms expunge_store_ids_imply_messages_same concurrent_store_expunge_independent_technical
  
  by (smt Pair_inject delivery_has_a_cause events_before_exist fst_conv msg_id_unique node_histories.prefix_of_appendD node_histories_axioms operation.distinct(15) operation.simps(25) imap.Broadcast_Store_Deliver_prefix_closed imap_axioms prefix_elem_to_carriers prefix_msg_in_history)
  	
lemma (in imap) concurrent_operations_commute:
  assumes "xs prefix of i"
  shows "hb.concurrent_ops_commute (node_deliver_messages xs)"                     
proof -
  { fix a b x y
    assume "(a, b) \<in> set (node_deliver_messages xs)"
           "(x, y) \<in> set (node_deliver_messages xs)"
           "hb.concurrent (a, b) (x, y)"
    hence "interp_msg (a, b) \<rhd> interp_msg (x, y) = interp_msg (x, y) \<rhd> interp_msg (a, b)" 
      apply(unfold interp_msg_def, case_tac "b"; case_tac "y"; simp add: add_add_commute rem_rem_commute append_append_commute add_append_commute add_expunge_commute add_store_commute expunge_expunge_commute hb.concurrent_def)
      								apply (metis (full_types) add_id_valid add_rem_commute assms concurrent_add_remove_independent prefix_contains_msg)+
      	
            apply (metis append_id_valid append_rem_ids_imply_messages_same assms concurrent_append_remove_independent_technical prefix_contains_msg rem_append_commute)
        
            		 apply (metis assms concurrent_expunge_remove_independent expunge_id_valid network.prefix_contains_msg network_axioms imap.rem_expunge_commute imap_axioms)
        
        apply (metis assms concurrent_store_remove_independent prefix_contains_msg rem_store_commute store_id_valid)
        
          apply (metis append_id_valid append_rem_ids_imply_messages_same assms concurrent_append_remove_independent_technical prefix_contains_msg rem_append_commute)
          apply (metis append_id_valid expunge_id_valid append_expunge_ids_imply_messages_same assms concurrent_append_expunge_independent_technical prefix_contains_msg append_expunge_commute)
        
          	 apply (metis append_id_valid append_store_commute assms concurrent_append_store_independent prefix_contains_msg store_id_valid)
        
          	apply (metis assms concurrent_expunge_remove_independent expunge_id_valid prefix_contains_msg rem_expunge_commute)
           apply (metis append_expunge_commute append_id_valid assms concurrent_append_expunge_independent expunge_id_valid prefix_contains_msg)
        
          
          apply (metis assms expunge_id_valid expunge_store_commute imap.concurrent_store_expunge_independent imap_axioms prefix_contains_msg store_id_valid)
        
         apply (metis assms concurrent_store_remove_independent prefix_contains_msg rem_store_commute store_id_valid)
  
        apply (metis append_id_valid append_store_commute assms imap.concurrent_append_store_independent imap_axioms prefix_contains_msg store_id_valid)
        
       apply (metis assms expunge_id_valid expunge_store_commute imap.concurrent_store_expunge_independent imap_axioms prefix_contains_msg store_id_valid)
        
        by (smt assms events_in_local_order network.delivery_has_a_cause network.hb.intros(2) network.msg_id_unique network_axioms node_histories.events_before_exist node_histories.prefix_elem_to_carriers node_histories_axioms imap.Broadcast_Store_Deliver_prefix_closed imap_axioms prefix_contains_msg prefix_of_appendD prod.sel(1) store_id_valid store_store_commute)
              
  } thus ?thesis
    by(fastforce simp: hb.concurrent_ops_commute_def)
qed

theorem (in imap) convergence:
  assumes "set (node_deliver_messages xs) = set (node_deliver_messages ys)"
      and "xs prefix of i" and "ys prefix of j"
    shows "apply_operations xs = apply_operations ys"
using assms by(auto simp add: apply_operations_def intro: hb.convergence_ext concurrent_operations_commute
                node_deliver_messages_distinct hb_consistent_prefix)
              
context imap begin

sublocale sec: strong_eventual_consistency weak_hb hb interp_msg
  "\<lambda>ops.\<exists>xs i. xs prefix of i \<and> node_deliver_messages xs = ops" "\<lambda>x.({},{})"
  apply(standard; clarsimp simp add: hb_consistent_prefix node_deliver_messages_distinct
        concurrent_operations_commute)
   apply(metis (no_types, lifting) apply_operations_def bind.bind_lunit not_None_eq
     hb.apply_operations_Snoc kleisli_def apply_operations_never_fails interp_msg_def)
  using drop_last_message apply blast
done

end
end

  