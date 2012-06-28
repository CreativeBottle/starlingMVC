package com.creativebottle.starlingmvc.errors
{
	import com.creativebottle.starlingmvc.reflection.MemberKind;

	public class UndefinedMemberKindError extends Error
	{
		public function UndefinedMemberKindError(kind:MemberKind)
		{
			super("ClassDescriptor: cannot parse: undefined member kind: " + kind);
		}
	}
}