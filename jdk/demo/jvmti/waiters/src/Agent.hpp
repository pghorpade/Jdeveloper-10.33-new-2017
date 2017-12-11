/*
 * @(#)Agent.hpp	1.3 04/07/27
 * 
 * Copyright (c) 2004, 2005, Oracle. All rights reserved.  
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * -Redistribution of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 * 
 * -Redistribution in binary form must reproduce the above copyright notice, 
 *  this list of conditions and the following disclaimer in the documentation
 *  and/or other materials provided with the distribution.
 * 
 * Neither the name of Sun Microsystems, Inc. or the names of contributors may 
 * be used to endorse or promote products derived from this software without 
 * specific prior written permission.
 * 
 * This software is provided "AS IS," without a warranty of any kind. ALL 
 * EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING
 * ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * OR NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN MIDROSYSTEMS, INC. ("SUN")
 * AND ITS LICENSORS SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE
 * AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS
 * DERIVATIVES. IN NO EVENT WILL SUN OR ITS LICENSORS BE LIABLE FOR ANY LOST 
 * REVENUE, PROFIT OR DATA, OR FOR DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL, 
 * INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY 
 * OF LIABILITY, ARISING OUT OF THE USE OF OR INABILITY TO USE THIS SOFTWARE, 
 * EVEN IF SUN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
 * 
 * You acknowledge that this software is not designed, licensed or intended
 * for use in the design, construction, operation or maintenance of any
 * nuclear facility.
 */

/* C++ Agent class */

class Agent {

  private:
    jrawMonitorID lock;
    Monitor     **monitor_list;
    unsigned      monitor_count;
    Thread *get_thread(jvmtiEnv *jvmti, JNIEnv *env, jthread thread);
    Monitor *get_monitor(jvmtiEnv *jvmti, JNIEnv *env, jobject object);

  public:
    Agent(jvmtiEnv *jvmti, JNIEnv *env, jthread thread);
    ~Agent();
    void vm_death(jvmtiEnv *jvmti, JNIEnv *env);
    void thread_start(jvmtiEnv *jvmti, JNIEnv *env, jthread thread);
    void thread_end(jvmtiEnv *jvmti, JNIEnv *env, jthread thread);
    void monitor_contended_enter(jvmtiEnv* jvmti, JNIEnv *env, 
		   jthread thread, jobject object);
    void monitor_contended_entered(jvmtiEnv* jvmti, JNIEnv *env,
		   jthread thread, jobject object);
    void monitor_wait(jvmtiEnv* jvmti, JNIEnv *env, 
		   jthread thread, jobject object, jlong timeout);
    void monitor_waited(jvmtiEnv* jvmti, JNIEnv *env,
		   jthread thread, jobject object, jboolean timed_out);
    void object_free(jvmtiEnv* jvmti, jlong tag);

};

